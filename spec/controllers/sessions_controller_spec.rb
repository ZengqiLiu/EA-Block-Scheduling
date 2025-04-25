require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  describe "GET #omniauth" do
    let(:auth_hash) do
      {
        "uid" => "12345",
        "provider" => "google",
        "info" => {
          "email" => "test@example.com",
          "name" => "John Doe"
        }
      }
    end

    before do
      request.env["omniauth.auth"] = auth_hash
    end

    context "when the user is valid and is an admin" do
      let!(:user) do
        User.create(
          uid: "12345",
          provider: "google",
          email: "test@example.com",
          first_name: "John",
          last_name: "Doe",
          role: "admin"
        )
      end

      it "creates a session and redirects to admin dashboard" do
        get :omniauth

        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(admin_dashboard_path)
      end
    end

    context "when the user is valid and is not an admin" do
      let!(:user) do
        User.create(
          uid: "12345",
          provider: "google",
          email: "test@example.com",
          first_name: "John",
          last_name: "Doe",
          role: "student"
        )
      end

      it "creates a session and redirects to students dashboard" do
        get :omniauth

        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(students_dashboard_path)
      end
    end

    context "when the user is invalid" do
      before do
        allow_any_instance_of(User).to receive(:valid?).and_return(false)
      end

      it "does not create a session and redirects to pages path with an alert" do
        get :omniauth

        expect(session[:user_id]).to be_nil
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Login failed. Your email address: test@example.com is not authorized to access this application.")
      end
    end
  end

  describe 'GET #logout' do
    before do
      # Simulate a logged-in user
      session[:user_id] = 1
    end

    it 'resets the session' do
      get :logout
      expect(session[:user_id]).to be_nil
    end

    it 'redirects to the pages path with a notice' do
      get :logout
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("You are logged out.")
    end
  end

  describe 'GET #failure' do
    it 'redirects to the pages path' do
      get :failure
      expect(response).to redirect_to(root_path)
    end
  end
end
