class RegistrationsController < ApplicationController
  include CoursesHelper

  def create
    registration_data = {
      year: params[:year],
      math_course_taken: params[:math_course].presence,
      science_course_taken: params[:science_course].presence,
      engineering_course_taken: params[:engineering_course].presence,
      wanted_math_course: params[:wanted_math_course].presence,
      wanted_science_course: params[:wanted_science_course].presence,
      wanted_engineering_course: params[:wanted_engineering_course].presence
    }

    taken_courses = [
      registration_data[:math_course_taken],
      registration_data[:science_course_taken],
      registration_data[:engineering_course_taken]
    ].compact

    wanted_courses = [
      registration_data[:wanted_math_course],
      registration_data[:wanted_science_course],
      registration_data[:wanted_engineering_course]
    ].compact

    failed = []

    wanted_courses.each do |sec_name|
      base = extract_base_code(sec_name)

      # --- Prereq Validation ---
      unmet_prereqs = (prerequisites[base] || []).reject do |pr|
        taken_courses.any? { |taken| course_satisfies?(taken, pr) }
      end

      # --- Coreq Validation ---
      unmet_coreqs = (corequisites[base] || []).reject do |coreq|
        taken_courses.any? { |taken| course_satisfies?(taken, coreq) } ||
        wanted_courses.any? { |w| course_satisfies?(w, coreq) }
      end

      unless unmet_prereqs.empty? && unmet_coreqs.empty?
        failed << {
          course: sec_name,
          missing_prereqs: unmet_prereqs,
          missing_coreqs: unmet_coreqs
        }
      end
    end

    if failed.any?
      flash[:error] = failed.map do |f|
        errors = []
        errors << "prerequisites: #{f[:missing_prereqs].join(', ')}" if f[:missing_prereqs].any?
        errors << "corequisites: #{f[:missing_coreqs].join(', ')}" if f[:missing_coreqs].any?
        "#{f[:course]} (missing #{errors.join('; ')})"
      end.join("; ")
      redirect_to register_path and return
    else
      flash[:notice] = "Successfully registered for: #{wanted_courses.join(', ')}"
      normalized = wanted_courses.map { |name| name.strip.upcase }
      normalized_standalone = normalized.select { |name| standalone_courses.include?(name) }
      normalized -= normalized_standalone
      puts "Normalized base codes: #{normalized.inspect}"
      puts "Standalone base codes: #{normalized_standalone.inspect}"
      redirect_to generate_blocks_path(course_codes: normalized, standalone_courses: normalized_standalone) and return
    end
  end

  private

  def course_satisfies?(taken_sec_name, required_base)
    taken = extract_base_code(taken_sec_name)
    taken_dept, taken_num = taken.split("-")
    req_dept, req_num = required_base.split("-")
    return false unless taken_dept == req_dept

    taken_num.to_i >= req_num.to_i
  end
end
