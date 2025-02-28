Given('I am on the registration page') do
  visit register_path
end

Then('I should see the registration form') do
  expect(page).to have_selector('form')
end

# Then('I should see {string}') do |text|
#   expect(page).to have_content(text)
# end

# Then('I should see the "Register" button') do
#   expect(page).to have_button('Register')
# end

When('I select {string} for {string}') do |value, field|
  case field
  when "Year"
    choose(value)  # Extracts "1" or "2" from "Year 1" or "Year 2"
  when "Math Course"
    select(value, from: 'math_course')
  when "Science Course"
    select(value, from: 'science_course')
  when "Engineering Course"
    select(value, from: 'engineering_course')
  else
    raise "Field not found: #{field}"
  end
end

When('I click on the "Register" button') do
  click_button('Register')
end

# Then('I should see {string}') do |text|
#   expect(page).to have_content(text)
# end
