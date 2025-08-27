# no topo do rails_helper.rb
require 'devise'

RSpec.configure do |config|
  # para request specs (sign_in / sign_out)
  config.include Devise::Test::IntegrationHelpers, type: :request
  # FactoryBot mais conciso (create, build, etc.)
  config.include FactoryBot::Syntax::Methods
end
