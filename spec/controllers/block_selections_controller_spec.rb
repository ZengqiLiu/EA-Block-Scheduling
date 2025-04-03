require 'rails_helper'

RSpec.describe BlockSelectionsController, type: :controller do
  let(:student_user) { FactoryBot.create(:user, role: :student) }
  let(:admin_user) { FactoryBot.create(:user, role: :admin) }
  let(:referer) { "http://test.host/some_page" }

  before do
    request.env["HTTP_REFERER"] = referer
  end

  describe "POST #create" do
    context "when user is not a student" do
      before do
        allow(controller).to receive(:current_user).and_return(admin_user)
      end

      it "redirects to root path with access denied alert" do
        post :create, params: { block: { courses: [1,2,3,4] } }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Access denied.")
      end
    end

    context "when user is a student" do
      before do
        allow(controller).to receive(:current_user).and_return(student_user)
      end

      context "with a valid block" do
        # Mock a valid block with 4 courses
        let!(:science_course) { FactoryBot.create(:course, :chem) }
        let!(:math_course) { FactoryBot.create(:course, :math) }
        let!(:engineering_course) { FactoryBot.create(:course, :engr) } 
        let!(:intro_course) { FactoryBot.create(:course, :clen) } 
        let(:courses) { [science_course, math_course, engineering_course, intro_course] }

        it "creates a block selection and redirects back with a success notice" do
          expect {
            post :create, params: { block: { courses: courses.map(&:id) } }
          }.to change(BlockSelection, :count).by(1)
          student_user.reload
          expect(student_user.block_selection).to be_present
          expect(student_user.block_selection.courses.pluck(:id)).to match_array(courses.map(&:id))
          expect(flash[:notice]).to eq("Block successfully selected.")
          expect(response).to redirect_to(referer)
        end
      end

      context "with an invalid block" do
        # Mock an invalid block with only 3 courses
        let!(:science_course) { FactoryBot.create(:course, :chem) }
        let!(:math_course) { FactoryBot.create(:course, :math) }
        let!(:intro_course) { FactoryBot.create(:course, :clen) } 
        let(:courses) { [science_course, math_course, intro_course] }

        it "does not create a block selection and redirects back with an alert" do
          expect {
            post :create, params: { block: { courses: courses.map(&:id) } }
          }.not_to change(BlockSelection, :count)
          expect(flash[:alert]).to eq("Invalid block")
          expect(response).to redirect_to(referer)
        end
      end
    end
  end
end
