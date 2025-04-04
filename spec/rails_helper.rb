# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'  # Exclude spec files
  add_filter '/config/'  # Exclude config files
  add_filter '/app/channels/'  # Exclude channels directory
  add_filter '/app/jobs/'      # Exclude jobs directory
  add_filter '/app/mailers/'   # Exclude mailers directory
  # add_filter '/app/models/'    # Exclude models directory
  add_filter 'app/channels/application_cable/channel.rb'  # Exclude specific files
  add_filter 'app/channels/application_cable/connection.rb'
  add_filter 'app/jobs/application_job.rb'
  add_filter 'app/mailers/application_mailer.rb'
  add_filter 'app/models/application_record.rb'

  # Keep only specific models and controllers
  add_filter do |source_file|
    file_path = source_file.filename
    included_paths = [
      'app/models/course.rb',
      'app/models/block.rb',
      'app/models/block_course.rb',
      'app/models/block_selection.rb',
      'app/controllers/courses_controller.rb',
      'app/controllers/blocks_controller.rb',
      'app/controllers/block_selections_controller.rb',
      'app/controllers/schedules_controller.rb',
      'app/controllers/application_controller.rb'  # Keep this as it's needed for inheritance
    ]

    # Return false to keep the file, true to filter it out
    !included_paths.any? { |path| file_path.include?(path) }
  end

  # Create groups for better organization
  add_group 'Controllers' do |source_file|
    source_file.filename.include?('app/controllers') &&
    (source_file.filename.include?('courses_controller.rb') ||
     source_file.filename.include?('blocks_controller.rb') ||
     source_file.filename.include?('application_controller.rb')) ||
     source_file.filename.include?('schedules_controller.rb') ||
     source_file.filename.include?('block_selections_controller.rb')
  end

  add_group 'Models' do |source_file|
    source_file.filename.include?('app/models') &&
    (source_file.filename.include?('course.rb') ||
     source_file.filename.include?('block.rb')) ||
     source_file.filename.include?('block_course.rb') ||
     source_file.filename.include?('block_selection.rb')
  end
end

# SimpleCov.start 'rails' # or 'rails', test_framework: 'rspec' if you're using RSpec
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is running in production
abort("The Rails environment is running in production mode!") if Rails.env.production?
# Uncomment the line below in case you have `--require rails_helper` in the `.rspec` file
# that will avoid rails generators crashing because migrations haven't been run yet
# return unless Rails.env.test?
require 'rspec/rails'
require 'database_cleaner'
require 'shoulda/matchers'

# Add additional requires below this line. Rails is not loaded until this point!
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Rails.root.glob('spec/support/**/*.rb').sort_by(&:to_s).each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]
  system('bin/webpack-dev-server &') if Rails.env.test?
  config.include FactoryBot::Syntax::Methods

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://rspec.info/features/7-0/rspec-rails
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
  config.include Rails.application.routes.url_helpers
  config.include ActionView::Helpers::UrlHelper
  config.include ActionView::Helpers::AssetTagHelper
  config.include ActionDispatch::TestProcess
  config.before(:each, type: :helper) do
    helper.default_url_options = { host: 'localhost:3000' }
  end
  # Set host for URL helpers
  Rails.application.routes.default_url_options[:host] = 'test.host'
  # Include Factory Bot syntax methods
  config.include FactoryBot::Syntax::Methods
end
RSpec.configure do |config|
  # Start Database Cleaner before each test
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

OmniAuth.config.test_mode = true
Capybara.default_driver = :rack_test
Capybara.javascript_driver = :selenium_chrome

Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
  provider: 'google_oauth2',
  uid: '123456',
  info: {
    email: 'testuser@example.com',
    first_name: 'Test',
    last_name: 'User'
  }
)

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
