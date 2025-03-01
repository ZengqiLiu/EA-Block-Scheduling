source "https://rubygems.org"

ruby "3.3.4"

gem "bootsnap", require: false # Reduces boot times through caching; required in config/boot.rb
gem "csv"
gem "pg" # PostgreSQL database adapter
gem "importmap-rails" # Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "jbuilder" # Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "omniauth-microsoft_graph"
gem "puma", ">= 5.0" # Use the Puma web server [https://github.com/puma/puma]
gem "rails", "~> 7.2.1" # Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "roo"  # For parsing Excel files
gem 'rubyXL'
gem 'activerecord-import'
gem "simple_form"  # For easier form handling
gem "sprockets-rails" # The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "stimulus-rails" # Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "turbo-rails" # Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
# gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "tzinfo-data", platforms: %i[windows jruby] # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# omniauth for google login
gem "omniauth"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection"

# Excel generation gems
gem "caxlsx"
gem "caxlsx_rails"

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end

group :test do
  gem "simplecov", require: false
  gem "selenium-webdriver"
  gem "ZenTest"
end

gem "dotenv-rails", groups: [:development, :test]

group :development, :test do
  gem "sqlite3", "~> 2.2.0" # Use SQLite for development and test environments
  gem "shoulda-matchers"
end

group :development, :test do
  gem "activestorage", "~> 7.2.1"
  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", "6.2.2", require: false
  gem "capybara"
  gem "cucumber-rails", require: false
  gem "database_cleaner"
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  # gem "debug", platforms: %i[mri mingw mswin x64_mingw], require: "debug/prelude"
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "rails-controller-testing"
  # Setting Rspec to dev
  gem "rspec"
  gem "rspec-rails"
  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
  gem "webdrivers"
  gem "factory_bot_rails"
end
