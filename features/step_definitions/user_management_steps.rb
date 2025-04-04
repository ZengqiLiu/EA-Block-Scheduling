Given("users exist") do
  @user1 = User.create!(
    email: "user1@example.com",
    first_name: "Alice",
    last_name: "Smith",
    role: "user",
    uid: "1001",
    provider: "google_oauth2"
  )
  @user2 = User.create!(
    email: "user2@example.com",
    first_name: "Bob",
    last_name: "Johnson",
    role: "user",
    uid: "1002",
    provider: "google_oauth2"
  )
end

Given("a user exists") do
  @user = User.create!(
    email: "user@example.com",
    first_name: "John",
    last_name: "Doe",
    role: "user",
    uid: "1003",
    provider: "google_oauth2"
  )
end

When("I visit the users index page") do
  visit users_path
end

When("I visit the user's show page") do
  visit user_path(@user)
end

When("I visit the user's edit page") do
  visit edit_user_path(@user)
end

When("I visit my profile page") do
  visit profile_path
end

When("I update the user's information") do
  fill_in "Email", with: "updated_user@example.com"
  fill_in "First Name", with: "UpdatedFirstName"
  fill_in "Last Name", with: "UpdatedLastName"
  click_button "Update User"
end

When("I delete the user") do
  visit user_path(@user)
  click_button "Remove user"
  expect(page).to have_content("User was successfully deleted.")
end

Then("I should see a list of users") do
  expect(page).to have_content(@user1.email)
  expect(page).to have_content(@user2.email)
end

Then("I should see a success message") do
  expect(page).to have_content("updated_user@example.com was successfully updated.")
end

Then("the user's information should be updated") do
  @user.reload
  expect(@user.email).to eq("updated_user@example.com")
  expect(@user.first_name).to eq("UpdatedFirstName")
  expect(@user.last_name).to eq("UpdatedLastName")
  expect(@user.role).to eq("admin")
end

Then("I should see a confirmation message") do
  expect(page).to have_content("User was successfully deleted.") # Adjust if necessary
end

Then("I should see the user's details as an admin") do
  expect(page).to have_content("John")
  expect(page).to have_content("user@example.com")
end

Then("I should see the spreadsheet upload button") do
  expect(page).to have_content("Import From Spreadsheet")
end

When('I upload a valid spreadsheet') do
  file_path = Rails.root.join('spec', 'fixtures', 'files', 'TEAC.xlsx')

  #attach_file('file-input', file_path, make_visible: true)
  find('input#file-input', visible: false).set(file_path)

  click_button 'Submit'
end

Then('I should see a success message saying {string}') do |message|
  expect(page).to have_content(message, wait: 5)
end

Then('the users should be created') do
  expect(User.count).to be > 0
end
