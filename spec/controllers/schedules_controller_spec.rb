# spec/controllers/schedules_controller_spec.rb

require 'rails_helper'

RSpec.describe SchedulesController, type: :controller do
  let(:user) { User.create!(email: "test@example.com", first_name: "Test", last_name: "User", uid: "123456789", provider: "google_oauth2") }
  before do
    # Simulate logged-in user by setting session[:user_id]
    session[:user_id] = user.id
  end
  describe "GET #generate_schedule" do
    it "returns a successful response" do
      get :generate_schedule
      expect(response).to have_http_status(:ok)
    end

    # it "assigns courses instance variable" do
    # get :generate_schedule
    # expect(assigns(:courses)).not_to be_nil
    # expect(assigns(:courses).size).to eq(3)
    #  end
  end
end
