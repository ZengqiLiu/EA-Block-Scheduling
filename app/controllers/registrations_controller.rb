class RegistrationsController < ApplicationController
  def new
  end

  def create
    registration_data = {
      year: params[:year],
      math_course: params[:math_course],
      science_course: params[:science_course],
      engineering_course: params[:engineering_course]
    }

    Rails.logger.info "New Registration Data: #{registration_data.inspect}"

    flash[:notice] = "Successfully registered!"

    redirect_to register_path
  end

  private

  def registration_params
    params.require(:registration).permit(:year, :math_course, :science_course, :engineering_course)
  end
end
