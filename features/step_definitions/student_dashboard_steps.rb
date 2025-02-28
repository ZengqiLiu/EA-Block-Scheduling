Then('I should see the {string} link') do |link_text|
  expect(page).to have_link(link_text)
end

When('I click on the {string} link') do |link_text|
  click_link(link_text)
end

Then('I should be on the registration page') do
  expect(current_path).to eq(register_path)
  expect(page).to have_content('Course Registration')
end
