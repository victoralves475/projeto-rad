# spec/models/user_spec.rb
require "rails_helper"

RSpec.describe User, type: :model do
  it "tem factory válida" do
    expect(build(:user)).to be_valid
  end

  it "não é suspenso por padrão" do
    u = build(:user)
    expect(u.suspended?).to be false
  end

  it "fica inativo para autenticação quando suspenso" do
    u = create(:user)
    u.update!(suspended_at: Time.current)
    expect(u).to be_suspended
    expect(u.active_for_authentication?).to be false
    expect(u.inactive_message).to eq(:suspended)
  end
end
