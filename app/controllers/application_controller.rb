class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # ビュー（erb）の中でも current_user メソッドを使えるように指定
  helper_method :current_user

  private

  def current_user
    # セッション（または認証トークン）からログイン中のユーザーを取得する処理
    # 例: session[:user_id] を使っている場合
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
  
end
