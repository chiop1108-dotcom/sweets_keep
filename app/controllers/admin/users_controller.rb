class Admin::UsersController < ApplicationController
  # 管理者以外のアドミン画面アクセスをブロック
  before_action :require_admin

  def index
    # 新しい順に並べる 500件ずつ表示
    @users = User.order(created_at: :desc)

    # 役割による絞り込み（?role=admin または ?role=generalなどの検索パラメータが入っているかを確認）
    # params[:role].present?: role パラメータが空でないか
    # User.roles.key?(params[:role]): 指定された値がUser モデルに定義されたEnumのキーとして正しく存在するか（不正なパラメータを防ぐ）
    if params[:role].present? && User.roles.key?(params[:role])
      # 指定された権限（role）のユーザーだけをデータベースから探す
      @users = @users.where(role: params[:role])
    end

    # ページネーションの適用
    @users = @users.page(params[:page]).per(500)
  end

  # 権限の切り替え（一般 ⇄ 管理者）
  def toggle_role
    @user = User.find(params[:id])
    
    # 最後の1人の管理者が自分自身を一般ユーザーに変更するのを防ぐ
    if @user == Current.user && @user.role_admin? && User.role_admin.count <= 1
      redirect_to admin_users_path, alert: "最後の管理者の権限を変更することはできません。"
      return
    end

    if @user.role_admin?
      @user.role_general!
    else
      @user.role_admin!
    end

    redirect_to admin_users_path, notice: "#{@user.user_name} さんの権限を変更しました。"
  end

  # 強制退会（物理削除＝完全消去）
  def destroy
    @user = User.find(params[:id])

    if @user == Current.user
      redirect_to admin_users_path, alert: "自分自身を退会させることはできません。"
      return
    end

    # データベースから削除
    if @user.destroy
      # status: :see_other を付けることでTurboの画面更新を確実に起動させます
      redirect_to admin_users_path, notice: "#{@user.user_name} さんと関連データを削除しました。", status: :see_other
    else
      redirect_to admin_users_path, alert: "削除に失敗しました。", status: :see_other
    end
  end

  private

  # 管理者権限のチェック
  def require_admin
    unless Current.user&.role_admin?
      redirect_to root_path, alert: "管理者権限が必要です。"
    end
  end
end