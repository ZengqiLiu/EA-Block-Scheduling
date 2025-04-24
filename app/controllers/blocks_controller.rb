class BlocksController < ApplicationController
  # before_action :require_admin
  # skip_before_action :require_admin, if: -> { Rails.env.test? }

  def index
    @blocks = defined?(@@generated_blocks) ? @@generated_blocks : []
    @generated_blocks = @blocks  # Keep this for backward compatibility if needed
    render :index
  end

  def generate
    courses = Course.all
    # Filter courses whose base_course_code matches a normalized wanted code
    normalized = params[:course_codes]
    selected_courses_sections = courses
      .select { |course| normalized.include?(course.base_course_code.upcase) }
    puts "Selected course count: #{selected_courses_sections.length}"
    puts "Selected courses: #{selected_courses_sections.map(&:sec_name).join(', ')}"
    @@generated_blocks = Block.generate_blocks(selected_courses_sections)
    redirect_to blocks_path, notice: "Generated #{@@generated_blocks.length} blocks! Review the generated blocks."
  end

  def preview
    if defined?(@@generated_blocks)
      @generated_blocks = @@generated_blocks
      render :preview
    else
      redirect_to blocks_path
    end
  end

  def export
    @blocks = defined?(@@generated_blocks) ? @@generated_blocks : []

    respond_to do |format|
      format.html { redirect_to blocks_path }
      format.xlsx {
        response.headers["Content-Disposition"] = 'attachment; filename="course_blocks.xlsx"'
        render xlsx: "export", locals: { blocks: @blocks }
      }
    end
  end
end
