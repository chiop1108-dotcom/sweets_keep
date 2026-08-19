class PostsController < ApplicationController
  # 未ログインでも閲覧可能な画面
  allow_unauthenticated_access only: [:index]
  # 未ログイン許可アクションでも、ログイン中なら Current.user を復元する
  before_action :resume_session, only: [:index]

  def new

    # フォーム用の空の新しいPostオブジェクトを作成
    @post = Post.new
  end

  def index
    # ベース：新しい投稿順にすべて取得
    @posts = Post.all.order(created_at: :desc)

    # キーワード検索（商品名 OR エリア OR 店名 OR 持ち歩き可能時間 OR 日持ち OR ジャンル OR 紹介文 OR 投稿者名）
    if params[:keyword].present?
      kw = "%#{params[:keyword]}%"
      # joins(:user) を使うことで、関連するユーザーテーブルの user_name も検索対象にできる
      @posts = @posts.joins(:user).where(
        "posts.product_name LIKE ? OR " \
        "posts.area LIKE ? OR " \
        "posts.shop_name LIKE ? OR " \
        "users.user_name LIKE ?", 
        # "posts.carry_time LIKE ? OR " \
        # "posts.shelf_life LIKE ? OR " \
        # "posts.genre LIKE ? OR " \
        # "posts.description LIKE ? OR " \
        kw, kw, kw, kw, 
        # kw, kw, kw, kw
      )
    end

    # ジャンル（genre）が指定されている場合、そのジャンルで絞り込む
    if params[:genre].present?
      @posts = @posts.where(genre: params[:genre])
    end

    # 持ち歩き時間（指定した時間「以下」 または 「常温OK」）
    if params[:carrying_time].present?
      if params[:carrying_time] == "free"
        @posts = @posts.where(carrying_time: "free")
      else
        @posts = @posts.where("carrying_time <= ?", params[:carrying_time])
      end
    end

    # 賞味期限（指定した日数「以上」）
    if params[:shelf_life].present?
      @posts = @posts.where("shelf_life >= ?", params[:shelf_life])
    end

  end

  def show
    # URLのidをもとに該当の投稿を1件取得（例: /posts/1）
    @post = Post.find(params[:id])
  end

  def create
    # 許可されたパラメータを使ってインスタンスを作成
    #フォームから送られてきたデータをセットした新しいオブジェクトを作成
    @post = Post.new(post_params)
    # ログイン中のユーザーIDをセット
    @post.user_id = Current.user.id

    # @post = Current.user.posts.build(post_params)は@post = Post.new(post_params)と@post.user_id = Current.user.idをまとめた書き方

    if @post.save
      # 保存成功：投稿一覧画面へリダイレクト
      redirect_to posts_path, notice: "投稿を作成しました"
    else
      # 保存失敗：入力内容を保持したまま新規作成画面（new.html.erb）を再描画
      flash.now[:alert] = "未入力の項目があります"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # URLのidをもとに該当の投稿を1件取得（例: /posts/1）
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post.id), notice: "投稿を編集しました"
    else
      flash.now[:alert] = "更新できませんでした"
      # バリデーションエラー時は編集画面（edit）を再描画する
      render :edit, status: :unprocessable_entity, locals: { post: @post }
    end
  end

  def destroy
    # URLのidをもとに該当の投稿を1件取得（例: /posts/1）
    post = Post.find(params[:id])
    # 投稿を削除
    post.destroy
    redirect_to posts_path, notice: "投稿を削除しました"
  end

  private
  
  # Strong Parameters（不正なデータ送信を防ぐセキュリティ機能）
  def post_params
    # :post キー配下の許可したいカラムを指定
    params.require(:post).permit(
      :product_name,
      :shop_name,
      :description,
      :rating,
      :starage_temperature,
      :carrying_time,
      :shelf_life,
      :area,
      :price,
      :genre,
      :image # ActiveStorageの画像
    )
  end

end
