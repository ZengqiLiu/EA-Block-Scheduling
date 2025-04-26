require 'rails_helper'

RSpec.describe CoursesController, type: :controller do
  describe "GET #index" do
    before(:each) do
      Course.delete_all  # Ensure database is clean
    end

    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    it "assigns @courses and @prerequisites" do
      # Create a course with all required attributes
      course = Course.create!(
        sec_name: "CSCE-121-001",
        prerequisites: "MATH-2412",
        category: "Engineering",
        term: "224F000",
        dept_code: "CSCE",
        days: "MW",
        start_time: "9:00 AM",
        end_time: "10:20 AM"
      )

      get :index

      # Debug output if test fails
      if assigns(:courses) != [course]
        puts "\nDebug Info:"
        puts "Expected course: #{course.attributes}"
        puts "Actual courses: #{assigns(:courses).map(&:attributes)}"
      end

      expect(assigns(:courses)).to match_array([course])
      expect(assigns(:prerequisites)).to eq({ "CSCE-121-001" => ["MATH-2412"] })
    end
  end

  describe "GET #show" do
    let(:course) { create(:course, prerequisites: "MATH-2412") }

    it "returns a successful response" do
      get :show, params: { id: course.id }
      expect(response).to be_successful
    end

    it "assigns @prerequisites correctly" do
      get :show, params: { id: course.id }
      expect(assigns(:prerequisites)).to eq(["MATH-2412"])
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_params) {
        { course: attributes_for(:course) }
      }

      it "creates a new course" do
        expect {
          post :create, params: valid_params
        }.to change(Course, :count).by(1)
      end

      it "redirects to courses path with success message" do
        post :create, params: valid_params
        expect(response).to redirect_to(courses_path)
        expect(flash[:notice]).to match(/successfully created/)
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) {
        { course: attributes_for(:course, sec_name: '', short_title: '') }
      }

      it "does not create a new course" do
        expect {
          post :create, params: invalid_params
        }.not_to change(Course, :count)
      end

      it "returns unprocessable entity status and renders new" do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "PATCH #update" do
    let(:course) { create(:course) }

    context "with valid parameters" do
      let(:new_attributes) {
        { short_title: 'Updated Title' }
      }

      it "updates the course" do
        patch :update, params: { id: course.id, course: new_attributes }
        course.reload
        expect(course.short_title).to eq('Updated Title')
      end

      it "redirects with success message" do
        patch :update, params: { id: course.id, course: new_attributes }
        expect(response).to redirect_to(course_path(course))
        expect(flash[:notice]).to match(/successfully updated/)
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) {
        { sec_name: '', short_title: '' }
      }

      it "returns unprocessable entity status and renders edit" do
        patch :update, params: { id: course.id, course: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:course) { create(:course) }

    it "destroys the course" do
      expect {
        delete :destroy, params: { id: course.id }
      }.to change(Course, :count).by(-1)
    end

    it "redirects with success message" do
      delete :destroy, params: { id: course.id }
      expect(response).to redirect_to(courses_path)
      expect(flash[:notice]).to match(/successfully deleted/)
    end
  end

  describe "POST #upload_courses_by_excel" do
    before(:each) do
      Course.delete_all
    end

    let(:mock_spreadsheet) { instance_double("Roo::Excelx") }
    let(:mock_sheet) { instance_double("Roo::Excelx::Sheet") }
    let(:uploaded_file) do
      temp = Tempfile.new(['sample', '.xlsx'])
      allow(temp).to receive(:path).and_return('/fake/path/sample.xlsx')
      Rack::Test::UploadedFile.new(temp, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
    end


    context "when no file is uploaded" do
      it "redirects with an alert message" do
        post :upload_courses_by_excel, params: {}
        expect(response).to redirect_to(courses_path)
        expect(flash[:alert]).to eq("No file uploaded.")
      end
    end

    context "when the uploaded file is valid" do
      before do
        allow(Roo::Excelx).to receive(:new).and_return(mock_spreadsheet)
        allow(mock_spreadsheet).to receive(:sheet).and_return(mock_sheet)

        # Setup the sheet
        allow(mock_sheet).to receive(:row).with(1).and_return(["Term", "Dept Code", "Crse Id", "Sec Name", "Start Time", "End Time"])
        allow(mock_sheet).to receive(:row).with(2).and_return(["224F000", "CSCE", "121", "CSCE-121-001", "09:00 AM", "10:20 AM"])
        allow(mock_sheet).to receive(:last_row).and_return(2)
      end

      it "creates courses and sets flash notice" do
        expect {
          post :upload_courses_by_excel, params: { file: uploaded_file }
        }.to change(Course, :count).by(1)

        expect(response).to redirect_to(courses_path)
        expect(flash[:notice]).to match(/courses uploaded successfully/)
        expect(flash[:alert]).to be_nil
      end
    end

    context "when there are invalid rows" do
      before do
        allow(Roo::Excelx).to receive(:new).and_return(mock_spreadsheet)
        allow(mock_spreadsheet).to receive(:sheet).and_return(mock_sheet)

        # Header
        allow(mock_sheet).to receive(:row).with(1).and_return(["Term", "Dept Code", "Crse Id", "Sec Name", "Start Time", "End Time"])
        # Row 2 - Valid course
        allow(mock_sheet).to receive(:row).with(2).and_return(["224F000", "CSCE", "121", "CSCE-121-001", "09:00 AM", "10:20 AM"])
        # Row 3 - Invalid course (missing Sec Name)
        allow(mock_sheet).to receive(:row).with(3).and_return(["224F000", "CSCE", "122", nil, "10:30 AM", "11:50 AM"])
        allow(mock_sheet).to receive(:last_row).and_return(3)
      end

      it "creates only valid courses and sets flash alert for failures" do
        expect {
          post :upload_courses_by_excel, params: { file: uploaded_file }
        }.to change(Course, :count).by(1)

        expect(response).to redirect_to(courses_path)
        expect(flash[:notice]).to match(/courses uploaded successfully/)
        expect(flash[:alert]).to be_present
        expect(flash[:alert]).to match(/Some rows failed to upload/)
      end
    end
  end
end
