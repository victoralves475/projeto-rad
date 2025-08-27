require "rails_helper"

RSpec.describe "Calculations PDF", type: :request do
  let(:user) { create(:user) }
  let!(:calc) { create(:calculation, user: user) }

  it "exige login" do
    get download_pdf_calculation_path(calc)
    expect(response).to redirect_to(new_user_session_path)
  end

  it "retorna application/pdf autenticado" do
    sign_in(user, scope: :user)
    get download_pdf_calculation_path(calc)
    expect(response.media_type).to eq("application/pdf")
    expect(response.body.byteslice(0,4)).to eq("%PDF")
  end
end
