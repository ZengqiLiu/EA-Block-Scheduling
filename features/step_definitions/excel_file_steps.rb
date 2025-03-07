require 'cucumber/rails'
include Rails.application.routes.url_helpers
World(Rails.application.routes.url_helpers)

Given("I am logged in as a test user") do
  # Create a test user in DB
  User.create!(
    email: 'testuser@example.com',
    first_name: 'Test',
    last_name: 'User',
    role: 'admin',
    uid: '67890',
  )
  # Mock the OmniAuth response for a test user
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    provider: 'google_oauth2',
    uid: '67890',  # Unique UID for the test user
    info: {
      email: 'testuser@example.com',  # Email for the test user
      name: 'Test User'               # Name for the test user
    }
  })

  # Simulate the login process by visiting the OmniAuth callback URL
  visit '/auth/google_oauth2/callback'

  # Set the role appropriately, if necessary
  @test_user = User.find_by(email: 'testuser@example.com')
  @test_user.update(role: 'admin') # Ensure the user has admin role for managing Excel files
end

Given("an Excel file exists") do
  @excel_file = ExcelFile.create!(
    name: "Test Excel File",
    file: Rack::Test::UploadedFile.new(
      Rails.root.join('spec', 'fixtures', 'files', 'test.xlsx'),
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    )
  )
end

When("I visit the Excel file's show page") do
  visit excel_file_path(@excel_file)
end

When("I am on the new excel file page") do
    visit new_excel_file_path
  end

When("I fill in {string} with {string}") do |field, value|
  fill_in field, with: value
end

When("I attach the file {string} to {string}") do |file, field|
  attach_file(field, Rails.root.join('spec', 'fixtures', 'files', file))
end

When("I click {string} on excel page") do |button|
  click_button button
end

When("I attempt to delete an Excel file with ID {string}") do |file_id|
  begin
    page.driver.submit :delete, excel_file_path(file_id), {}
  rescue ActiveRecord::RecordNotFound
  end
end

Then("I should see {string}") do |content|
  expect(page).to have_content(content)
end
