# spec/views/schedule_viewer_spec.rb
require 'rails_helper'

RSpec.describe "schedule_viewer.html.erb", type: :view do
  before do
    render template: "schedules/schedule_viewer"
  end

  # it "displays the page title" do
  # expect(rendered).to have_selector("h1", text: "Schedule Viewer")
  # end

  # it "displays table headers for each day of the week" do
  # ["Time", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"].each do |day|
  #   expect(rendered).to have_selector("th", text: day)
  # end
  # end

  # it "displays the modal for class details" do
  # expect(rendered).to have_selector("#classModal.class-modal")
  # expect(rendered).to have_selector(".modal-content")
  # end

  # it "has a close button in the modal" do
  #   expect(rendered).to have_selector(".close", text: "×")
  # end

  # context "when there are class blocks" do
  #   it "displays a class block" do
  #     expect(rendered).to have_selector(".class-block", minimum: 1)
  #   end

  # TODO: Add setup for specific class block data and test for presence
  # end
end
