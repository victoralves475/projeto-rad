# spec/rails_helper.rb
# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

# Carrega RSpec Rails
require 'rspec/rails'

# >>> ADIÇÕES IMPORTANTES <<<
require 'devise'
require 'factory_bot_rails'

# Add additional requires below this line. Rails is not loaded until this point!

# Carrega automaticamente helpers em spec/support/**
Rails.root.glob('spec/support/**/*.rb').sort_by(&:to_s).each { |f| require f }
# Garante que o schema de teste está atualizado
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # Fixtures (se usar)
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  # Transações por teste
  config.use_transactional_fixtures = true

  # >>> ADIÇÕES IMPORTANTES <<<
  # FactoryBot: usar create/build diretamente
  config.include FactoryBot::Syntax::Methods

  # Devise helpers para request specs (sign_in / sign_out)
  config.include Devise::Test::IntegrationHelpers, type: :request
  # (opcionais, caso venha a usar)
  # config.include Devise::Test::ControllerHelpers, type: :controller
  # config.include Devise::Test::IntegrationHelpers, type: :system

  # Habilita inferência de tipo de spec pelo caminho (models, requests, etc.)
  config.infer_spec_type_from_file_location!

  # Limpa backtrace de gems Rails
  config.filter_rails_from_backtrace!
  # config.filter_gems_from_backtrace("gem name")
end
