require "rails_helper"

RSpec.describe Admin::UsersHelper, type: :helper do
  it "carrega o helper" do
    expect(helper).to be_a(Admin::UsersHelper)
  end
end
