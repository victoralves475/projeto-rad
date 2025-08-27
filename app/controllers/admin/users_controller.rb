module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin!

    layout "authenticated"

    def index
      @users = User.order(admin: :desc, created_at: :desc).page(params[:page]).per(20)
    end

    def suspend
      user = User.find(params[:id])
      if user == current_user
        redirect_to admin_users_path, alert: "Você não pode suspender a si mesmo." and return
      end
      user.update!(suspended_at: Time.current)
      redirect_to admin_users_path, notice: "Usuário #{user.email} suspenso."
    end

    def reactivate
      user = User.find(params[:id])
      user.update!(suspended_at: nil)
      redirect_to admin_users_path, notice: "Usuário #{user.email} reativado."
    end

    private

    def require_admin!
      authorize! :manage, User  # CanCanCan
      # Se não estiver usando CanCanCan, troque por:
      # redirect_to authenticated_root_path, alert: "Acesso não autorizado." unless current_user&.admin?
    end
  end
end
