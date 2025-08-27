require "rails_helper"

RSpec.describe "Admin::Users", type: :request do
  let(:admin) { create(:user, admin: true) }

  describe "GET /admin/users" do
    it "retorna 200 para admin autenticado" do
      sign_in(admin, scope: :user)
      get admin_users_path
      expect(response).to have_http_status(:ok)
    end
  end
end
