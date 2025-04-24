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
      puts "⚠️ No file uploaded"
      redirect_to courses_path and return
    end

    puts "📂 Uploading file: #{uploaded_file.original_filename}"
    puts "🔗 Assigned as_id: #{as_id}"

    spreadsheet = Roo::Excelx.new(uploaded_file.path)
    sheet = spreadsheet.sheet(0)
    headers = sheet.row(1).map { |h| h.to_s.strip.gsub("\n", " ") }

    puts "📋 Headers: #{headers.inspect}"

    inserted = 0
    failed_rows = []

    (2..sheet.last_row).each do |i|
      row_data = Hash[[headers, sheet.row(i)].transpose]
      puts "📄 Row #{i}: #{row_data.inspect}"


      parsed_start, parsed_end = get_parsed_times(row_data["Start Time"], row_data["End Time"])

      if row_data["Sec Name"]&.strip == "CHEM 1109"
        puts "🔍 Matched CHEM 1109 @ Row #{i}: #{row_data.inspect}"
        puts "🔍 Start Time: #{parsed_start}"
        puts "🔍 End Time: #{parsed_end}"
      end

      if row_data["Sec Name"]&.strip == "CHEM-1109-001"
        puts "🔍 Matched CHEM-1109-001 @ Row #{i}: #{row_data.inspect}"
        puts "🔍 Start Time: #{parsed_start}"
        puts "🔍 End Time: #{parsed_end}"
      end


      course = Course.new(
        term: row_data["Term"],
        dept_code: row_data["Dept Code"]&.strip,
        course_id: row_data["Crse Id"],
        sec_coreq_secs: row_data["Coreq Secs"],
        syn: row_data["Syn"],
        sec_name: row_data["Sec Name"],
        short_title: row_data["Short Title"],
        im: row_data["IM"],
        building: row_data["Bldg"],
        room: row_data["Room"],
        days: row_data["Days"],
        start_time: parsed_start,
        end_time: parsed_end,
        fac_id: row_data["Fac ID"],
        faculty_name: row_data["Faculty Name"],
        crs_capacity: row_data["Crs Capacity"],
        sec_cap: row_data["Sec Cap"],
        student_count: 0,
        notes: row_data["NOTES"],
        prerequisites: nil,
        corequisites: nil,
        category: nil,
        as_id: as_id
      )

      if course.save
        inserted += 1
        puts "✅ Inserted: #{course.sec_name} (row #{i})"
      else
        error_message = course.errors.full_messages.join(", ")
        puts "❌ Failed row #{i}: #{error_message}"
        failed_rows << { row: i, errors: course.errors.full_messages }
      end
    end

    puts "📊 Upload complete. Inserted: #{inserted}, Failed: #{failed_rows.size}"

    flash[:notice] = "#{inserted} courses uploaded successfully."
    flash[:alert] = "Some rows failed to upload: #{failed_rows.inspect}" if failed_rows.any?
    redirect_to courses_path
  end

  def parse_time_value(t)
    return nil if t.blank?

    t = t.to_s.strip

    if t =~ /^\d+$/  # If it's all digits, assume it's seconds
      seconds = t.to_i
      Time.at(seconds).utc.strftime("%I:%M %p") # e.g., 50400 => "02:00 PM"
    else
      Time.parse(t).strftime("%I:%M %p") rescue t
    end
  end

  def get_parsed_times(start_time_raw, end_time_raw)
    start_times = start_time_raw.to_s.split(/\n+/).map { |t| parse_time_value(t) }.compact
    end_times   = end_time_raw.to_s.split(/\n+/).map { |t| parse_time_value(t) }.compact

    parsed_start = start_times.min
    parsed_end   = end_times.max

    [parsed_start, parsed_end]
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
