require "rails_helper"

RSpec.describe "Kick suspended user", type: :request do
  let(:user) { create(:user) }

  it "desloga e redireciona para login ao acessar qualquer página protegida" do
    sign_in(user, scope: :user)
    # simula suspensão durante a sessão
    user.update!(suspended_at: Time.current)

    get dashboard_path
    expect(response).to redirect_to(new_user_session_path)

    follow_redirect!
    expect(response.body).to include("suspens") # pega "suspensa" / "suspenso" em pt-BR
  end
end
