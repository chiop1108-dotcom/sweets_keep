class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
end

def require_admin
  unless Current.user&.admin?
    redirect_to root_path, alert: "管理者権限が必要です"
  end
end