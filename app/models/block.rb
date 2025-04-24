class Block
  include ActiveModel::Validations

  attr_accessor :courses, :id

  def initialize(courses = [], id = nil)
    @id = id || SecureRandom.uuid
    @courses = courses.map { |c| c.is_a?(Course) ? c : Course.find(c) }
  end

  # Validations
  # validates_length_of :courses, is: 3, message: "must have exactly 4 courses"
  validate :no_time_conflicts
  # validate :has_required_category
  validate :no_duplicate_course_numbers
  # validate :no_prerequisites_in_block

  # Add this method to help with creation
  def self.create_with_courses(courses)
    block = Block.new
    block.course_ids = courses.map(&:id)  # Assign courses using IDs
    block
  end

  def self.generate_blocks(courses)
    valid_blocks = []
    return valid_blocks if courses.blank?

    # all_courses = Course.all.to_a
    unique_courses = courses.uniq { |course| course.base_course_code }

    # Rails.logger.info "Found #{all_courses.length} total courses"
    Rails.logger.info "Found #{unique_courses.length} matching unique base courses"

    # Simplified combination check
    courses.combination(unique_courses.length).each do |course_combo|
      add_valid_block(valid_blocks, course_combo)
    end

    Rails.logger.info "Generation complete. Found #{valid_blocks.length} valid blocks."
    valid_blocks
  end

  private

  def self.add_valid_block(valid_blocks, course_combo)
    block = new(course_combo)
    # puts course_combo
    # puts "*********************"
    # puts block.courses.map(&:sec_name).join(", ")
    # puts "*********************"
    puts SecureRandom.uuid
    if block.valid?
      # puts "=========================="
      # puts "Found valid block #{valid_blocks.length + 1}: #{block.courses.map(&:sec_name).join(', ')}"
      valid_blocks << block
      Rails.logger.info "Found valid block #{valid_blocks.length}: #{block.courses.map(&:sec_name).join(', ')}" if valid_blocks.length % 10 == 0
    end
  end

  def no_time_conflicts
    return unless courses.any?

    course_list = courses.to_a

    course_list.each_with_index do |course1, i|
      course_list[(i + 1)..-1].each do |course2|
        if time_conflict?(course1, course2)
          errors.add(:base, "Time conflict between #{course1.sec_name} and #{course2.sec_name}")
        end
      end
    end
  end

  def time_conflict?(course1, course2)
    return false unless course1.days.present? && course2.days.present?

    # Get individual days for each course
    days1 = parse_to_individual_days(course1.days)
    days2 = parse_to_individual_days(course2.days)

    # Check if they share any days
    common_days = days1 & days2
    return false if common_days.empty?

    # If they share days, check time overlap
    start1 = Time.parse(course1.start_time.to_s)
    end1 = Time.parse(course1.end_time.to_s)
    start2 = Time.parse(course2.start_time.to_s)
    end2 = Time.parse(course2.end_time.to_s)

    !(end1 <= start2 || end2 <= start1)
  end

  def parse_to_individual_days(days_string)
    return [] unless days_string.present?
    days = []

    # Simplified day checks
    add_days_to_array(days, days_string)
    days
  end

  def add_days_to_array(days, days_string)
    return unless days_string.present?

    day_patterns = {
      "M" => "M",
      "W" => "W",
      "Th" => "Th",
      "F" => "F"
    }

    # Handle T/TTh separately since it has special logic
    days << "T" if days_string.match?(/^(T|TTh)$/)

    # Handle other days
    day_patterns.each do |pattern, day|
      days << day if days_string.include?(pattern)
    end
  end

  def has_required_category
    required_categories = ["Science", "Math", "Engineering"]

    # Check each required category
    required_categories.each do |category|
      # Check if any course in the block matches the required category
      unless courses.any? { |course| course.respond_to?(:category) && course.category == category }
        errors.add(:base, "Block must include at least one #{category} course")
      end
    end
  end

  def no_prerequisites_in_block
    courses.each do |course|
      # Skip if no prerequisites
      next if course.prerequisites.blank?

      # Get base course codes for current block
      current_course_codes = courses.map { |c| c.base_course_code }

      # Get prerequisite codes for this course
      prereq_codes = course.get_prerequisites

      # Check if any prerequisites are in the current block
      if prereq_codes.any? { |prereq| current_course_codes.include?(prereq) }
        errors.add(:base, "Cannot include #{course.sec_name} with its prerequisites")
        return false
      end
    end
    true
  end

  def no_duplicate_course_numbers
    return unless courses.present?
    course_numbers = get_course_numbers

    if course_numbers.uniq.length != course_numbers.length
      errors.add(:base, "Cannot have multiple sections of the same course")
    end
  end

  private

  def get_course_numbers
    courses.map do |course|
      next unless course.is_a?(Course)
      parts = course.sec_name.split(/[-\s]/)
      parts.take(2).join("-")
    end.compact
  end
end
