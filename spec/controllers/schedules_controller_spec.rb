# spec/controllers/schedules_controller_spec.rb

require 'rails_helper'

RSpec.describe SchedulesController, type: :controller do
  # let(:user) { User.create!(email: "test@example.com", first_name: "Test", last_name: "User", uid: "123456789", provider: "google_oauth2") }
  # before do
    # Simulate logged-in user by setting session[:user_id]
    #   session[:user_id] = user.id
  # end
  # describe "GET #generate_schedule" do
    # it "returns a successful response" do
      # get :generate_schedule
      # expect(response).to have_http_status(:ok)
    # end

    # it "assigns courses instance variable" do
    # get :generate_schedule
    # expect(assigns(:courses)).not_to be_nil
    # expect(assigns(:courses).size).to eq(3)
    #  end
  # end

  describe "GET #schedule_viewer" do
    context "when current_user has a block_selection" do
      let(:student_user) { FactoryBot.create(:user, role: :student) }
      
      let!(:science_course) { FactoryBot.create(:course, :chem) }
      let!(:math_course) { FactoryBot.create(:course, :math) }
      let!(:engineering_course) { FactoryBot.create(:course, :engr) } 
      let!(:intro_course) { FactoryBot.create(:course, :clen) } 
      let(:courses) { [science_course, math_course, engineering_course, intro_course] }

      before do
        block_selection = BlockSelection.create!(user: student_user)
        courses.each do |course|
          BlockCourse.create!(block_selection: block_selection, course: course)
        end

        allow(controller).to receive(:current_user).and_return(student_user)
        get :schedule_viewer
      end

      it "assigns @selected_courses with courses from the block_selection" do
        expect(assigns(:selected_courses)).to match_array(courses)
      end
    end

    context "when current_user does not have a block_selection" do
      let(:student_user) { FactoryBot.create(:user, role: :student) }
      before do
        allow(controller).to receive(:current_user).and_return(student_user)
        get :schedule_viewer
      end
      it "assigns @selected_courses as an empty array" do
        expect(assigns(:selected_courses)).to be_empty
      end
    end
  end
end
