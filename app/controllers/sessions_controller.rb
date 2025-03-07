class SessionsController < ApplicationController
  skip_before_action only: [:omniauth]
  include ApplicationHelper

  def logout
    reset_session
    redirect_to root_path, notice: "You are logged out."
  end

  def failure
    redirect_to root_path
  end

  # GET /auth/google_oauth2/callback
  def omniauth
    auth = request.env["omniauth.auth"]
    email = auth["info"]["email"]

    # Try to find the user by email
    @user = User.find_by(email: email)

    if @user && @user.valid?
      session[:user_id] = @user.id
      # Redirect based on user role
      if current_user_admin?
        redirect_to admin_dashboard_path
      else
        redirect_to students_dashboard_path
      end
    else
      redirect_to root_path, alert: "Login failed."
    end
  end
end
