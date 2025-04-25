require 'rails_helper'

RSpec.describe BlocksController, type: :controller do
  let!(:math_course) { create(:course, :math) }
  let!(:science_course) { create(:course, :science) }
  let!(:engineering_course) { create(:course, category: 'Engineering') }

  # Clean up class variable between tests
  after(:each) do
    if BlocksController.class_variable_defined?(:@@generated_blocks)
      BlocksController.remove_class_variable(:@@generated_blocks)
    end
  end

  describe "GET #index" do
    it "returns empty array when no blocks generated" do
      get :index
      expect(assigns(:blocks)).to eq([])
    end
  end

  describe "POST #generate" do
    it "generates new blocks and redirects to index" do
      post :generate, params: { course_codes: [], standalone_courses: [] }
      expect(response).to redirect_to(blocks_path)
      expect(flash[:notice]).to include("Generated")
    end
  end

  describe "GET #preview" do
    it "redirects to blocks path when no blocks generated" do
      get :preview
      expect(response).to redirect_to(blocks_path)
    end

    it "succeeds when blocks are generated" do
      post :generate, params: { course_codes: [], standalone_courses: [] }
      get :preview
      expect(response).to be_successful
    end
  end

  describe "GET #export" do
    context "when no blocks generated" do
      it "returns xlsx file" do
        get :export, format: :xlsx
        expect(response.content_type).to eq(
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        )
        expect(response.headers['Content-Disposition']).to include('export.xlsx')
      end
    end

    context "when blocks are generated" do
      before do
        post :generate
      end

      it "returns xlsx file" do
        get :export, format: :xlsx
        expect(response.content_type).to eq(
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        )
        expect(response.headers['Content-Disposition']).to include('export.xlsx')
      end

      it "redirects html format to blocks path" do
        get :export, format: :html
        expect(response).to redirect_to(blocks_path)
      end
    end
  end
end
