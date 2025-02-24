# spec/views/select_block/select_block_spec.rb

require 'rails_helper'

RSpec.describe "select_block.html.erb", type: :view do
  before do
    assign(:block_count, 10)
    render template: "select_block/select_block"
  end

  it "displays the page title" do
    expect(rendered).to have_content("Select Your Block")
  end

  it "displays the same number of blocks as {block_count} " do
    expect(rendered).to have_css("div.block-to-select", count: assigns(:block_count))
  end

  it "displays the select button" do
    expect(rendered).to have_button("Select Block")
  end

end