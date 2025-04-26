class BlocksController < ApplicationController
  # before_action :require_admin
  # skip_before_action :require_admin, if: -> { Rails.env.test? }

  def index
    @blocks = defined?(@@generated_blocks) ? @@generated_blocks : []
    @generated_blocks = @blocks  # Keep this for backward compatibility if needed
    @standalone_courses_group = defined?(@@standalone_courses_group) ? @@standalone_courses_group : {}
    # puts "Standalone courses grouped: #{@standalone_courses_group.inspect}"
    render :index
  end

  def generate
    courses = Course.all
    # Filter courses whose base_course_code matches a normalized wanted code
    normalized = params[:course_codes] || []
    normalized_standalone = params[:standalone_courses] || []

    selected_courses_sections = courses
      .select { |course| normalized.include?(course.base_course_code.upcase) }

    puts "Selected course count: #{selected_courses_sections.length}"
    puts "Selected courses: #{selected_courses_sections.map(&:sec_name).join(', ')}"
    @@generated_blocks = Block.generate_blocks(selected_courses_sections)

    standalone_courses_sections = courses
    .select { |course| normalized_standalone.include?(course.base_course_code.upcase) }

    @@standalone_courses_group = standalone_courses_grouped(standalone_courses_sections)
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


  def standalone_courses_grouped(courses)
    courses.group_by { |course| course.base_course_code.upcase }
  end

  def options_from_collection_for_select(collection, value_method, label_method, selected = nil)
    collection.map do |item|
      value = item.public_send(value_method)
      label = label_method.respond_to?(:call) ? label_method.call(item) : item.public_send(label_method)
      selected_attr = selected.to_s == value.to_s ? " selected" : ""
      "<option value=\"#{ERB::Util.html_escape(value)}\"#{selected_attr}>#{ERB::Util.html_escape(label)}</option>"
    end.join.html_safe
  end
end
