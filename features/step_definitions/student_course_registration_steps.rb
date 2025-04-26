# features/step_definitions/student_course_registration_steps.rb

Given('I am on the registration page abc') do
  visit register_path
end

Given('the following registration courses exist abc:') do |table|
  table.hashes.each do |row|
    Course.create!(
      dept_code: row["dept_code"],
      sec_name: row["sec_name"],
      short_title: row["short_title"],
      term: "224F000", # dummy term
      start_time: "9:00 AM",
      end_time: "10:00 AM",
      days: "MW",
      crs_capacity: 30,
      sec_cap: 0,
      student_count: 0
    )
  end
end

Then('I should see the registration form abc') do
  expect(page).to have_selector('form')
end

Then('I should see {string} abc') do |text|
  expect(page).to have_content(text)
end

Then('I should see the {string} button abc') do |button_text|
  expect(page).to have_button(button_text)
end

FIELD_IDS = {
  "Math Course" => "math_course",
  "Science Course" => "science_course",
  "Engineering Course" => "engineering_course",
  "Wanted Math Course" => "wanted_math_course",
  "Wanted Science Course" => "wanted_science_course",
  "Wanted Engineering Course" => "wanted_engineering_course"
}

When('I select {string} for {string} abc') do |value, field|
  field_id = FIELD_IDS[field]
  raise "Unknown field '#{field}'" unless field_id
  select(value, from: field_id)
end

When('I click on the {string} button abc') do |button_text|
  click_button(button_text)
end

Then('I should be redirected to the blocks page abc') do
  expect(page).to have_current_path(blocks_path)
end

Then('I should stay on the registration page abc') do
  expect(page).to have_current_path(register_path)
end

Then('I should see a flash notice {string} abc') do |message|
  expect(page).to have_content(message)
end

Then('I should see a flash error containing {string}') do |partial_message|
  expect(page).to have_content(/#{Regexp.escape(partial_message)}/i)
end
