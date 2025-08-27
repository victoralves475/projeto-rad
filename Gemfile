source "https://rubygems.org"

ruby "3.3.0"

gem "rails", "~> 8.0.2", ">= 8.0.2.1"

# Web server
gem "puma", ">= 5.0"

# Assets e front-end
gem "propshaft"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"

# APIs
gem "jbuilder"

# Cache, filas, Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Performance
gem "bootsnap", require: false

# Deploy (opcional)
gem "kamal", require: false
gem "thruster", require: false

# Banco de dados Postgres (ajuste: tirar sqlite e usar pg)
gem "pg", ">= 1.5"

# --- GEMS EXIGIDAS PELO PROFESSOR ---
# Autenticação
gem "devise"
# Autorização
gem "cancancan"
# Paginação
gem "kaminari"

group :development, :test do
  # Debug
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  # Segurança
  gem "brakeman", require: false
  # Estilo Ruby
  gem "rubocop-rails-omakase", require: false

  # Testes
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers", require: false
end

group :test do
  gem "sqlite3", "~> 2.1"
end


# Windows (timezone)
gem "tzinfo-data", platforms: %i[windows jruby]

gem "devise-i18n", "~> 1.15"

gem "prawn", "~> 2.5"
gem "prawn-table", "~> 0.2.2"

gem "simplecov", "~> 0.22.0"
