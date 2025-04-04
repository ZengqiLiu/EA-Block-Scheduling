Given("the following block exist:") do |table|
  block_courses = table.hashes.map do |course_hash|
    case course_hash["category"]
    when "Science"
      FactoryBot.create(:course, :chem, sec_name: course_hash["sec_name"], dept_code: course_hash["dept_code"],
                        days: course_hash["days"], start_time: Time.parse(course_hash["start_time"]),
                        end_time: Time.parse(course_hash["end_time"]))
    when "Math"
      FactoryBot.create(:course, :math, sec_name: course_hash["sec_name"], dept_code: course_hash["dept_code"],
                        days: course_hash["days"], start_time: Time.parse(course_hash["start_time"]),
                        end_time: Time.parse(course_hash["end_time"]))
    when "Engineering"
      FactoryBot.create(:course, :engr, sec_name: course_hash["sec_name"], dept_code: course_hash["dept_code"],
                        days: course_hash["days"], start_time: Time.parse(course_hash["start_time"]),
                        end_time: Time.parse(course_hash["end_time"]))
    when "Intro"
      FactoryBot.create(:course, :clen, sec_name: course_hash["sec_name"], dept_code: course_hash["dept_code"],
                        days: course_hash["days"], start_time: Time.parse(course_hash["start_time"]),
                        end_time: Time.parse(course_hash["end_time"]))
    else
      FactoryBot.create(:course, sec_name: course_hash["sec_name"], dept_code: course_hash["dept_code"],
                        days: course_hash["days"], start_time: Time.parse(course_hash["start_time"]),
                        end_time: Time.parse(course_hash["end_time"]))
    end
  end
  @generated_block = Block.new(block_courses)
  @generated_blocks = [@generated_block]
  BlocksController.class_variable_set(:@@generated_blocks, @generated_blocks)
end

And ("I am on the blocks page") do
  visit blocks_path
end
  
When("I select a valid block of the following courses:") do |table|
  @selected_course_sec_names = table.raw.drop(1).flatten
  courses = Course.where(sec_name: @selected_course_sec_names)
  # page.driver.post block_selections_path, { block: { courses: courses.pluck(:id) } }
  click_button "SELECT BLOCK"
end
  
Then("I should see a flash message {string}") do |message|
    expect(page).to have_content(message)
end

Then("my block selection should include the following courses:") do |table|
  expected_sec_names = table.raw.drop(1).flatten
  actual_sec_names = @user.block_selection.courses.pluck(:sec_name)
  expect(actual_sec_names).to match_array(expected_sec_names)
end

  
Then("I should be remain on the blocks page") do
  expect(page.current_path).to eq(blocks_path)
end
  