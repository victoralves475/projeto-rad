require 'rails_helper'

RSpec.describe "Dashboard", type: :request do
  let(:user) { create(:user) }

  it "redireciona não autenticado para login" do
    get dashboard_path
    expect(response).to redirect_to(new_user_session_path)
  end

  it "retorna 200 para autenticado" do
    sign_in(user, scope: :user)
    get dashboard_path
    expect(response).to have_http_status(:ok)
  end
end
