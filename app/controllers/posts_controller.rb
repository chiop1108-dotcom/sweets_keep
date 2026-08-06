class PostsController < ApplicationController
  def new
    # フォーム用の空の新しいPostオブジェクトを作成
    @post = Post.new
  end

  def index
    # 新しい投稿順にすべて取得
    @posts = Post.all.order(created_at: :desc)
  end

  def show
    # URLのidをもとに該当の投稿を1件取得（例: /posts/1）
    @post = Post.find(params[:id])
  end

  def create
    # 許可されたパラメータを使ってインスタンスを作成
    #フォームから送られてきたデータをセットした新しいオブジェクトを作成
    @post = Post.new(post_params)

    # 開発初期でログイン機能未実装の場合は、仮のユーザーIDをセット（ログイン機能実装後は current_user.posts.build(post_params) に変更）
    # @post.user_id = User.first.id

    if @post.save
      # 保存成功：投稿詳細画面へリダイレクト
      redirect_to post_path(@post), notice: "投稿を作成しました"
    else
      # 保存失敗：入力内容を保持したまま新規作成画面（new.html.erb）を再描画
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  # Strong Parameters（不正なデータ送信を防ぐセキュリティ機能）
  def post_params
    # :post キー配下の許可したいカラムを指定
    params.require(:post).permit(:product_name, :shop_name, :description, :rating, :starage_temperature, :carrying_time, :shelf_life, :area, :price, :image)
  end

end
