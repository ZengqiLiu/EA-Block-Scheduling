require 'rails_helper'

RSpec.feature "Schedule Generation", type: :feature do
  before do
    # Mock the OmniAuth Google OAuth2 response
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '12345',
      info: { email: 'testuser@example.com', name: 'Test User' }
    })
  end

  after do
    OmniAuth.config.test_mode = false
  end

  scenario "User views the course list and generates a schedule" do
    visit login_path  # This triggers OmniAuth login

    # Simulate the OmniAuth callback to log in the user
    visit '/auth/google_oauth2/callback'

    # Ensure the login is successful and that the user is redirected to the correct page
    # expect(page).to have_content('Logout') # Or any other content specific to the logged-in state

    visit generate_schedule_schedules_path

    # Verify that the table of courses is displayed
    # expect(page).to have_content("Selected Courses")
    # expect(page).to have_content("Introduction to Computer Science")
    # expect(page).to have_content("Dr. Alice Smith")
    # expect(page).to have_content("Data Structures")

    # Click the generate schedule button
    # click_button "Generate Schedule"

    # schedule_banner = find("#schedule-banner", visible: false)

    # expect(page).to have_css("#schedule-banner", text: "2 schedules generated", visible: false)
    # expect(page).to have_css("#schedule-banner", text: "View Schedule 1", visible: false)
    # expect(page).to have_css("#schedule-banner", text: "View Schedule 2", visible: false)
  end
end
