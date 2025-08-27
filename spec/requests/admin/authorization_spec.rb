require "rails_helper"

RSpec.describe "Admin authorization", type: :request do
  let(:admin) { create(:user, admin: true) }
  let(:user)  { create(:user) }

  context "usuário comum autenticado" do
    it "não acessa /admin/users (redireciona com alerta)" do
      sign_in(user, scope: :user)
      get admin_users_path
      expect(response).to redirect_to(authenticated_root_path)
      follow_redirect!
      expect(response.body).to include("Acesso não autorizado").or include("não autorizado")
    end
  end

  context "admin autenticado" do
    it "acessa /admin/users (200)" do
      sign_in(admin, scope: :user)
      get admin_users_path
      expect(response).to have_http_status(:ok)
    end

    it "suspende e reativa um usuário" do
      sign_in(admin, scope: :user)
      patch suspend_admin_user_path(user)
      expect(response).to redirect_to(admin_users_path)
      expect(user.reload).to be_suspended

      patch reactivate_admin_user_path(user)
      expect(response).to redirect_to(admin_users_path)
      expect(user.reload).not_to be_suspended
    end
  end
end
