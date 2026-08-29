class UsersController < ApplicationController
  # 認証をスキップ: サインアップ（new, create）はログイン前に行うため
  allow_unauthenticated_access only: [:new, :create, :show]
  # @user を事前にセット
  before_action :set_user, only: [:show, :edit, :update, :unsubscribe, :destroy]
  # 1. ログインチェック（未ログインならログイン画面へ）
  before_action :require_authentication, only: [:edit, :update, :unsubscribe, :destroy]
  # 2. 本人チェック（他人ならリダイレクト）
  before_action :ensure_correct_user, only: [:edit, :update, :unsubscribe, :destroy]

  def unsubscribe
  end

  def edit
  end

  def show  
  # 表示するタブ
  @tab = params[:tab] || 'posts'
  # お気に入り投稿の一覧を取得して変数に入れる
  @favorite_posts = @user.favorite_posts

  if @tab == 'favorites'
    # 自分がいいねした投稿を取得
    @posts = @user.favorite_posts.includes(:user, :favorites, :tags).order(created_at: :desc)
  else
    # ユーザーが投稿した一覧を取得
    @posts = @user.posts.includes(:tags).order(created_at: :desc)
  end
end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "プロフィールを更新しました"
    else
      flash.now[:alert] = "更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    terminate_session
    redirect_to new_user_path, notice: "退会手続きが完了しました"
  end

  def new
    # フォーム用の空の新しいUserオブジェクトを作成
    @user = User.new
  end

  def create
    # 許可されたパラメータを使ってインスタンスを作成
    #フォームから送られてきたデータをセットした新しいオブジェクトを作成
    @user = User.new(user_params)
   
    if @user.save
      # 登録成功時：ログイン状態にしてマイページ（またはトップ）へリダイレクト
      # 会員登録が完了した直後に自動ログインさせる
      start_new_session_for @user
      redirect_to user_path(@user), notice: "会員登録が完了しました！"
    else
      # 登録失敗時：新規登録画面を再描画
      flash.now[:alert] = "入力内容に不備があります。確認してください。"
      render :new, status: :unprocessable_entity
    end
  end

  private

  # コントローラー内で何度も使う同じ処理をまとめたメソッド
  # 重複していた @user の取得を共通化
  def set_user
    @user = User.find(params[:id])
  end

  # Strong Parameters（不正なデータ送信を防ぐセキュリティ機能）
  def user_params
    # :user キー配下の許可したいカラムを指定
    # password_confirmation（パスワード再確認用）
    params.require(:user).permit(
      :name,
      :name_kana,
      :user_name,
      :email_address,
      :telephone_number,
      :password,
      :password_confirmation,
      :profile_text,
      :profile_image
    )
  end

  # 本人以外のアクセス制限用メソッド
  # eidt, update, destroyアクションの直前に呼び出される
  def ensure_correct_user
    @user = User.find(params[:id])
    # @userとCurrent.userが一致しない場合にログインユーザーのマイページへ遷移
    #（unlessは「〜でなければ」という意味）
    unless @user == Current.user
      redirect_to user_path(Current.user), alert: "他人のプロフィールは編集できません"
    end
  end

end
