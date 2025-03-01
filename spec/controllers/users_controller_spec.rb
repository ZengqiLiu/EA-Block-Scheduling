# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user0) { User.create!(email: "test@example.com", first_name: "Test", last_name: "User", role: "admin", uid: "123456789", provider: "google_oauth2") }
  let(:user2) { User.create!(email: "test2@example.com", first_name: "Test2", last_name: "User2", uid: "123456780", provider: "google_oauth2") }
  let(:user3) { User.create!(email: "test3@example.com", first_name: "Test3", last_name: "User3", uid: "123456782", provider: "google_oauth2") }
  let(:user4) { User.create!(email: "test4@example.com", first_name: "Test4", last_name: "User4", uid: "123456781", provider: "google_oauth2") }

  # Helper to simulate login via OmniAuth
  def simulate_login(user)
    request.env["omniauth.auth"] = {
      "uid" => user.uid,
      "provider" => user.provider,
      "info" => {
        "email" => user.email,
        "first_name" => user.first_name,
        "last_name" => user.last_name
      }
    }
    session[:user_id] = user.id
  end

  before do
    # Simulate logged-in user by setting session[:user_id]
    session[:user_id] = user0.id
  end

  describe 'GET #profile' do
    let(:user) { User.create!(email: "test.mctest@example.com", first_name: "Test", last_name: "User", role: "admin", uid: "123456789", provider: "google_oauth2") }

    before do
      simulate_login(user)  # Simulate the login here using OmniAuth mock
    end

    it 'assigns the current user to @user' do
      get :profile
      expect(assigns(:user)).to eq(user)
    end

    it 'renders the profile template' do
      get :profile
      expect(response).to render_template(:profile)
    end

    it 'responds successfully with HTTP 200' do
      get :profile
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #index" do
    let(:admin_user) { create(:user, role: "admin") }
    let(:regular_user) { create(:user) }

    context "with admin user rights" do
      before do
        simulate_login(admin_user)  # Simulate login for admin user
      end

      it 'returns a successful response' do
        get :index
        expect(response).to be_successful
      end
    end

    context "with normal user rights" do
      before do
        simulate_login(regular_user)  # Simulate login for regular user
      end

      it "returns message and redirects to root path" do
        get :index
        expect(response).to redirect_to(root_path + "login")
        expect(flash[:alert]).to eq("You don't have access to this page.")
      end
    end
  end

  describe "GET #edit" do
    it "renders the edit template" do
      get :edit, params: { id: user0.id }
      expect(response).to render_template(:edit)
    end

    it "assigns the correct user to @user" do
      get :edit, params: { id: user0.id }
      expect(assigns(:user)).to eq(user0)
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      it "updates the user and redirects to the user's profile" do
        patch :update, params: { id: user0.id, user: { first_name: "NewName" } }
        user0.reload
        expect(user0.first_name).to eq("NewName")
        expect(response).to redirect_to(user0)
      end
    end
  end

  describe "GET #show" do
    it "renders the show template" do
      get :show, params: { id: user0.id }
      expect(response).to render_template(:show)
    end

    it "assigns the correct user to @user" do
      get :show, params: { id: user0.id }
      expect(assigns(:user)).to eq(user0)
    end
  end

  describe 'POST #upload' do
    let(:valid_file) { fixture_file_upload('TEAC.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') }
    let(:invalid_file) { fixture_file_upload('invalid_file.txt', 'text/plain') }

    context 'with a valid file' do
      it 'uploads users and redirects to the users index' do
        allow(UserService).to receive(:process_users_spreadsheet).and_return(true)

        post :upload, params: { file: valid_file }

        expect(response).to redirect_to(users_path)
        expect(flash[:success]).to eq("Users have been uploaded successfully.")
      end
    end

    context 'with an invalid file' do
      it 'does not upload users and renders the upload form' do
        allow(UserService).to receive(:process_users_spreadsheet).and_raise(StandardError, "Invalid file format")

        post :upload, params: { file: invalid_file }

        expect(flash[:error]).to eq("An error occurred while processing the file: Invalid file format")
      end
    end

    context 'with no file selected' do
      it 'does not upload users and renders the upload form' do
        post :upload, params: { file: nil }

        expect(flash[:error]).to eq("No file selected or file is invalid.")
      end
    end
  end
end
