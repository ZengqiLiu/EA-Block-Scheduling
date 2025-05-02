class AdminCourseController < ApplicationController
  before_action :require_admin
  def viewer
    puts "[ADMIN COURSE VIEWER] Controller invoked"
    puts "[PARAMS] course_id: #{params[:course_id].inspect}"

    @courses = Course.order(:sec_name)
    puts "[COURSES LOADED] Total courses: #{@courses.count}"

    @selected_course_id = params[:course_id]
    @selected_course = Course.find_by(id: @selected_course_id) if @selected_course_id.present?

    if @selected_course
      puts "[COURSE FOUND] #{@selected_course.sec_name} (ID: #{@selected_course.id})"
      puts "[QUERY] Fetching students enrolled in this course..."

      @students = User
        .joins(block_selection: :block_courses)
        .where(block_courses: { course_id: @selected_course.id })
        .where(role: "student")
        .distinct

      puts "[RESULT] Found #{@students.count} student(s) enrolled in #{@selected_course.sec_name}:"
      @students.each do |student|
        puts "  - #{student.first_name} #{student.last_name} (#{student.email})"
      end
    else
      puts "[INFO] No course selected or course not found."
      @students = []
    end
  end
end
