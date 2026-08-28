class PostsController < ApplicationController
  # 未ログインでも閲覧可能な画面
  allow_unauthenticated_access only: [:index]
  # 未ログイン許可アクションでも、ログイン中なら Current.user を復元する
  before_action :resume_session, only: [:index]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  # 編集・更新は「投稿者本人」のみ許可
  before_action :authorize_owner!, only: [:edit, :update]
  # 削除は「投稿者本人」または「管理者」のみ許可
  before_action :authorize_owner_or_admin!, only: [:destroy]

  def new
    # フォーム用の空の新しいPostオブジェクトを作成
    @post = Post.new
  end

  def index
    # ベース：新しい投稿順にすべて取得
    # comments, user, tagsを事前読み込みしておく　処理が重くならない
    @posts = Post.includes(:comments, :user, :tags).order(created_at: :desc)
  end

  def show
    @comment = Comment.new
  end

 def create
    # 許可されたパラメータを使ってインスタンスを作成
    @post = Post.new(post_params)
    # ログイン中のユーザーIDをセット
    @post.user_id = Current.user.id

    if @post.save
      # 保存成功：タグの保存を実行
      @post.save_tags(params[:post][:tag_names]) if post_params[:tag_names].present?
      redirect_to posts_path, notice: "投稿を作成しました"
    else
      # 保存失敗：入力内容を保持したまま新規作成画面（new.html.erb）を再描画
      flash.now[:alert] = "未入力の項目があります"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

 def update
    if @post.update(post_params)
      # 更新成功：タグの更新を実行
      @post.save_tags(post_params[:tag_names]) if post_params[:tag_names].present?      redirect_to post_path(@post.id), notice: "投稿を編集しました"
    else
      flash.now[:alert] = "更新できませんでした"
      # バリデーションエラー時は編集画面（edit）を再描画する
      render :edit, status: :unprocessable_entity, locals: { post: @post }
    end
  end

  def destroy
    # 投稿を削除
    @post.destroy
    redirect_to posts_path, notice: "投稿を削除しました"
  end

  private

  # コントローラー内で何度も使う同じ処理をまとめたメソッド
  # 重複していた @post の取得を共通化
  def set_post
    @post = Post.find(params[:id])
  end

  # 本人チェック（編集・更新用）
  def authorize_owner!
    unless @post.user == Current.user
      redirect_to posts_path, alert: "他人の投稿を編集することはできません。"
    end
  end

  # 本人または管理者チェック（削除用）
  def authorize_owner_or_admin!
    unless @post.user == Current.user || Current.user&.role_admin?
      redirect_to posts_path, alert: "削除する権限がありません。"
    end
  end
  
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
      :image, # ActiveStorageの画像
      :tag_names  # カンマ区切りのタグ文字列を許可
    )
  end

end
