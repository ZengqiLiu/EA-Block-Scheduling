class UsersController < ApplicationController
  include ApplicationHelper
  before_action :require_admin, only: [:index, :show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
    user_id = params[:id]
    @user = User.find(user_id)
  end

  def edit
    @user = User.find(params[:id])
  end

  def profile
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find params[:id]
    @user.update!(user_params)
    flash[:notice] = "#{@user.email} was successfully updated."
    redirect_to user_path
  end

  def upload

    if params[:file].present?
      uploaded_file = params[:file]
      @file_path = uploaded_file.original_filename

      begin
        UserService.process_users_spreadsheet(uploaded_file)
        flash[:success] = "Users have been uploaded successfully."
        redirect_to users_path
      rescue => e
        flash[:error] = "An error occurred while processing the file: #{e.message}"
        return
      end
    else
      flash[:error] = "No file selected or file is invalid."
      return
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice: "User was successfully deleted."
  end

  private

  def user_params
    permitted = [:email, :first_name, :last_name, :uid, :provider]
    permitted << :role if current_user.admin?
    params.require(:user).permit(permitted)
  end
end
