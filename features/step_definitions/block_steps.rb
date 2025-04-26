# Navigation
When('I visit the blocks page') do
  visit blocks_path
end

When('I visit the preview page') do
  visit preview_blocks_path
end

# # Actions
# When('I click the generate blocks button') do
#   click_button('GENERATE NEW BLOCKS')
# end

When('I click the export link') do
  click_link('EXPORT TO EXCEL')
end

# Validations
Then('I should see a {string} button') do |button_text|
  expect(page).to have_button(button_text)
end

Then('I should see an {string} link') do |link_text|
  expect(page).to have_link(link_text)
end

Then('I should see blocks with courses') do
  expect(page).to have_css('.blocks-container')
  expect(page).to have_css('.block')
end

Then('I should be redirected to blocks page') do
  expect(current_path).to eq(blocks_path)
end

Then('I should see preview controls') do
  expect(page).to have_content('PREVIEW GENERATED BLOCKS')
  expect(page).to have_button('Save These Blocks')
  expect(page).to have_link('Generate New Ones')
  expect(page).to have_link('Back to Current Blocks')
end
