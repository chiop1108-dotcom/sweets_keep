class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      redirect_to user_path(user), notice: "ログインしました"
    else
      redirect_to new_session_path, alert: "メールアドレスまたはパスワードが正しくありません"
    end
  end

  def destroy
    terminate_session
  
    # 残っているフラッシュメッセージをすべて削除する
    # flash.clear 
    
    # または「ログアウトしました」で上書きする場合
    redirect_to new_session_path, notice: "ログアウトしました"
    
    # redirect_to new_session_path
  end
  
end
