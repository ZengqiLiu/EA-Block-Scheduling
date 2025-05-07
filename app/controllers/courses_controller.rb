require "time"

class CoursesController < ApplicationController
  include CoursesHelper
  # before_action :authenticate_user!
  # before_action :admin_only, only: [:upload, :new, :create, :edit, :update, :destroy]
  before_action :set_course, only: %i[ show edit update destroy ]

  # GET /courses or /courses.json
  def index
    @courses = Course.all.order(:sec_name)
    @excel_files = ExcelFile.all
    # @course = Course.new
    @excel_file = ExcelFile.new
    @prerequisites = {}
    @corequisites = {}
    @categories = {}


    @courses.each do |course|
      if course.prerequisites.present?
        @prerequisites[course.sec_name] = course.prerequisites.split(", ").map(&:strip)
      end
      if course.corequisites.present?
        @corequisites[course.sec_name] = course.corequisites.split(", ").map(&:strip)
      end
    end
  end

  # GET /courses/1 or /courses/1.json
  def show
    @prerequisites = @course.prerequisites&.split(", ")&.map(&:strip)
  end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)

    if @course.save
      flash[:notice] = "#{@course.short_title} was successfully created."
      redirect_to courses_path
    else
      flash.now[:alert] = @course.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    if @course.update(course_params)
      flash[:notice] = "#{@course.short_title} was successfully updated."
      redirect_to course_path(@course)
    else
      flash.now[:alert] = @course.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    @course = Course.find(params[:id])
    @course.destroy
    flash[:notice] = "Course was successfully deleted"
    redirect_to courses_path
  end

  def upload_courses_by_excel
    uploaded_file = params[:file]
    as_id = params[:as_id] || SecureRandom.uuid

    unless uploaded_file
      flash[:alert] = "No file uploaded."
      redirect_to courses_path and return
    end

    puts "📂 Uploading CSV file: #{uploaded_file.original_filename}"
    puts "🔗 Assigned as_id: #{as_id}"

    require "csv"

    inserted = 0
    failed_rows = []

    CSV.foreach(uploaded_file.path, headers: true) do |row|
      row_data = row.to_h.transform_keys(&:strip)

      # Extract course data
      sec_name = row_data["Course"].to_s.strip
      faculty_name = row_data["Instructor"]&.strip
      building     = row_data["Location"]&.strip
      room         = row_data["Room"]&.strip
      days         = row_data["Days"]&.strip
      syn          = row_data["Syn"]&.strip
      term         = row_data["Term"]&.strip
      time_slots  = row_data["Time"]&.strip
      first_course_part = sec_name.split("/").first.strip
      dept_code = first_course_part.split.first

      raw_time_slots = time_slots.to_s.split(",").map(&:strip)

      time_slots = raw_time_slots.map do |slot|
        start_str, end_str = slot.split("-").map(&:strip)
        begin
          parsed_start = Time.parse(start_str).strftime("%I:%M %p")
          parsed_end = Time.parse(end_str).strftime("%I:%M %p")
          "#{parsed_start} - #{parsed_end}"
        rescue
          nil
        end
      end.compact

      puts "Processing course: #{sec_name}"
      course = Course.new(
        term: term,
        dept_code: dept_code,
        course_id: nil,
        sec_name: sec_name,
        syn: syn,
        short_title: nil,
        im: nil,
        building: building,
        room: room,
        days: days,
        time_slots: time_slots.join(", "),
        fac_id: nil,
        faculty_name: faculty_name,
        crs_capacity: nil,
        sec_cap: nil,
        student_count: 0,
        notes: nil,
        prerequisites: nil,
        corequisites: nil,
        category: nil,
        as_id: as_id
      )

      if course.save
        inserted += 1
        # puts "✅ Inserted: #{sec_name}"
      else
        puts "❌ Failed to insert row: #{course.errors.full_messages.join(', ')}"
        failed_rows << { row: row_data, errors: course.errors.full_messages }
      end
    end

    puts "📊 Upload complete. Inserted: #{inserted}, Failed: #{failed_rows.size}"

    flash[:notice] = "#{inserted} courses uploaded successfully."
    flash[:alert] = "Some rows failed to upload: #{failed_rows.inspect}" if failed_rows.any?
    redirect_to courses_path
  end

  # Helper to split and normalize time ranges like "9:00AM - 10:20AM"
  def parse_time_range(time_range)
    return [nil, nil] if time_range.blank?

    cleaned = time_range.gsub("::", ":")  # Fix any double colons
    parts = cleaned.split("-").map(&:strip)

    begin
      start_time = Time.parse(parts[0]).strftime("%I:%M %p") rescue nil
      end_time   = Time.parse(parts[1]).strftime("%I:%M %p") rescue nil
    rescue
      start_time, end_time = nil, nil
    end

    [start_time, end_time]
  end


  def new
    @course = Course.new
  end

  # show recently uploaded courses
  def show_by_upload
    as_id = params[:as_id]
    validate_courses(as_id)
    @courses = Course.where(as_id: as_id)
  end

  # Gets the course code from the sec_name (e.g. MATH-2414 from MATH-2414-007)
  # def extract_base_code(sec_name)
  #   standardized = sec_name.gsub(' ', '-')
  #   parts = standardized.split('-')
  #   "#{parts[0]}-#{parts[1]}"
  # end

  private

  # Define prereqs and coreqs for listed courses for populating columns during creation
  # def corequisites
  #   {
  #     'ENGR 102' => %w[MATH-2412 MATH-2413],
  #     'ENGR 216' => ['PHYS 2425'],
  #     'ENGR 217' => ['PHYS 2426']
  #   }
  # end
  # def prerequisites
  #   {
  #     'MATH-2413' => ['MATH-2412'],
  #     'MATH-2414' => ['MATH-2413'],
  #     'MATH-2415' => ['MATH-2414'],
  #     'MATH-2420' => ['MATH-2415'],
  #     'ENGR-216' => %w[ENGR-102 MATH-2413],
  #     'ENGR-217' => %w[ENGR-216 PHYS-2425 MATH-2414],
  #     'CHEM-1312' => ['CHEM-1309'],
  #     'CHEM-1112' => ['CHEM-1309'],
  #     'PHYS-2425' => ['MATH-2413'],
  #     'PHYS-2426' => %w[MATH-2414 PHYS-2425]
  #   }
  # end

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.find(params[:id])
  end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(
        :term,
        :dept_code,
        :course_id,
        :sec_coreq_secs,
        :syn,
        :sec_name,
        :short_title,
        :im,
        :building,
        :room,
        :days,
        :start_time,
        :end_time,
        :fac_id,
        :faculty_name,
        :crs_capacity,
        :sec_cap,
        :student_count,
        :notes,
        :as_id,
        :prerequisites,
        :corequisites,
        :category
      )
    end

  # def admin_only
  #   unless current_user.admin?
  #     flash[:alert] = "User is not authorized to perform this action."
  #     redirect_to courses_path
  #   end
  # end
end
