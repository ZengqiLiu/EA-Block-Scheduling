class SchedulesController < ApplicationController
  def generate_schedule
  # Mock course data
  @courses = [
    { name: "Introduction to Computer Science", instructor: "Dr. Alice Smith", course_code: "CS101" },
    { name: "Data Structures", instructor: "Dr. Mark Lee", course_code: "CS202" },
    { name: "Operating Systems", instructor: "Prof. Emily Johnson", course_code: "CS301" }
  ]
  end

  before_action :require_login

  def schedule_viewer
    if current_user.block_selection.present?
      block_course_ids = current_user.block_selection.course_ids
    else
      block_course_ids = []
    end

    standalone_course_ids = StandaloneCourse.where(user_id: current_user.id).pluck(:course_id)

    all_course_ids = block_course_ids + standalone_course_ids
    @selected_courses = Course.where(id: all_course_ids)
  end

  def require_login
    unless current_user
      redirect_to login_path, alert: "Please log in to view your schedule."
    end
  end
end
