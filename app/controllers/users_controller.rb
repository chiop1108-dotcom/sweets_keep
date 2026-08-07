class UsersController < ApplicationController
  # 認証をスキップ: サインアップ（new, create）はログイン前に行うため
  allow_unauthenticated_access only: [:new, :create] 

  def mypage
  end

  def edit
  end

  def show
    @user = User.find(params[:id])
    # リレーションを利用し、ユーザーが投稿した記事一覧を表示する場合
    @posts = @user.posts.order(created_at: :desc)
  end

  def update
  end

  def destroy
  end

  def new
    # フォーム用の空の新しいUserオブジェクトを作成
    @user = User.new
  end

  def create
    # 許可されたパラメータを使ってインスタンスを作成
    #フォームから送られてきたデータをセットした新しいオブジェクトを作成
    @user = User.new(user_params)
    # 会員登録が完了した直後に自動ログインさせる
    session[:user_id] = @user.id

    if @user.save
      # 登録成功時：ログイン状態にしてマイページ（またはトップ）へリダイレクト
      # session[:user_id] = @user.id (認証機能実装後に有効化)
      redirect_to user_path(@user), notice: "会員登録が完了しました！"
    else
      # 登録失敗時：新規登録画面を再描画
      render :new, status: :unprocessable_entity
    end
  end

  private

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
    )
  end

end
