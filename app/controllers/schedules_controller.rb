class SchedulesController < ApplicationController
  # def generate_schedule
    # Mock course data
    # @courses = [
    #   { name: "Introduction to Computer Science", instructor: "Dr. Alice Smith", course_code: "CS101" },
    #   { name: "Data Structures", instructor: "Dr. Mark Lee", course_code: "CS202" },
    #   { name: "Operating Systems", instructor: "Prof. Emily Johnson", course_code: "CS301" }
# ]
  # end
  before_action :require_login

  def schedule_viewer
    if current_user.block_selection.present?
      @selected_courses = Course.where(id: current_user.block_selection.course_ids)
    else
      @selected_courses = []
    end
  end

  def require_login
    unless current_user
      redirect_to login_path, alert: "Please log in to view your schedule."
    end
  end
end
