require 'rails_helper'

RSpec.describe "Calculations", type: :request do
  let(:user) { create(:user) }

  before { sign_in(user, scope: :user) }

  describe "GET /calculations/new" do
    it "retorna 200" do
      get new_calculation_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /calculations" do
    it "cria e redireciona para o dashboard" do
      params = {
        calculation: {
          processo:  "00000012345678901234",
          crime:     "Furto",
          pena:      "1 ano, 0 meses, 0 dias",
          start_date: Date.today.to_s,
          age:        30
        }
      }

      expect {
        post calculations_path, params: params
      }.to change(Calculation, :count).by(1)

      expect(response).to redirect_to(dashboard_path)
    end
  end

  describe "GET /calculations/:id" do
    it "retorna 200" do
      calc = create(:calculation, user: user)
      get calculation_path(calc)
      expect(response).to have_http_status(:ok)
    end
  end
end
