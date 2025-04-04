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

    # Look up the user by email instead of creating a new one.
    @user = User.find_by(email: email)

    if @user
      # update the user's uid
      @user.update(uid: auth["uid"], provider: auth["provider"])
      session[:user_id] = @user.id

      Rails.logger.info "Successful login for #{@user.email} via OmniAuth."

      # Redirect based on user role
      if current_user_admin?
        redirect_to admin_dashboard_path
      else
        redirect_to students_dashboard_path
      end
    else
      Rails.logger.warn "Unauthorized login attempt with email #{email}."
      redirect_to root_path, alert: "Login failed. Your email address: #{email} is not authorized to access this application."
    end
  end
end
