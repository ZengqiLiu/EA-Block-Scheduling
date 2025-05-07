class Block
  include ActiveModel::Validations

  attr_accessor :courses, :id

  def initialize(courses = [], id = nil)
    @id = id || SecureRandom.uuid
    @courses = courses.map { |c| c.is_a?(Course) ? c : Course.find(c) }
  end

  # Validations
  validate :no_time_conflicts
  validate :no_duplicate_course_numbers

  # Add this method to help with creation
  def self.create_with_courses(courses)
    block = Block.new
    block.course_ids = courses.map(&:id)  # Assign courses using IDs
    block
  end

  def self.generate_blocks(courses)
    valid_blocks = []
    return valid_blocks if courses.blank?

    unique_courses = courses.uniq { |course| course.base_course_code }
    puts "Unique courses: #{unique_courses.map(&:sec_name).join(', ')}"
    courses.combination(unique_courses.length).each do |course_combo|
      puts "Checking combination: #{course_combo.map(&:sec_name).join(', ')}"
      add_valid_block(valid_blocks, course_combo)
    end

    valid_blocks
  end

  private

  def self.add_valid_block(valid_blocks, course_combo)
    block = new(course_combo)
    if block.valid?
      valid_blocks << block
    end
  end

  def no_time_conflicts
    return unless courses.any?

    course_list = courses.to_a

    course_list.each_with_index do |course1, i|
      course_list[(i + 1)..-1].each do |course2|
        # puts "Checking before time conflict between #{course1.sec_name} and #{course2.sec_name}"
        if time_conflict?(course1, course2)
          errors.add(:base, "Time conflict between #{course1.sec_name} and #{course2.sec_name}")
        end
      end
    end
  end

  def time_conflict?(course1, course2)
    # puts "Checking time conflict between #{course1.sec_name} and #{course2.sec_name}"
    return false unless course1.days.present? && course2.days.present?

    sessions1 = expand_sessions(course1.days, course1.time_slots)
    sessions2 = expand_sessions(course2.days, course2.time_slots)
    # puts "Sessions for #{course1.sec_name}: #{sessions1.inspect}"
    # puts "Sessions for #{course2.sec_name}: #{sessions2.inspect}"

    sessions1.each do |day1, start1, end1|
      sessions2.each do |day2, start2, end2|
        if day1 == day2 && overlap?(start1, end1, start2, end2)
          return true
        end
      end
    end

    false
  end

  def expand_sessions(days_input, time_slots_input)
    expanded = []

    # Fix here: properly split days and times if comma-separated
    days_list = days_input.is_a?(Array) ? days_input : days_input.split(",").map(&:strip)
    time_slots_list = time_slots_input.is_a?(Array) ? time_slots_input : time_slots_input.split(",").map(&:strip)

    days_list.each_with_index do |days_string, idx|
      time_range = time_slots_list[idx] || time_slots_list.first
      next if days_string.blank? || time_range.blank?

      start_str, end_str = time_range.split("-").map(&:strip)
      start_time = Time.parse("2000-01-01 #{start_str} UTC")
      end_time = Time.parse("2000-01-01 #{end_str} UTC")

      str = days_string.dup.upcase
      day_letters = []
      day_letters << "Th" if str.sub!("TH", "")
      day_letters << "M" if str.sub!("M", "")
      day_letters << "T" if str.sub!("T", "")
      day_letters << "W" if str.sub!("W", "")
      day_letters << "F" if str.sub!("F", "")

      day_letters.each do |day|
        expanded << [day, start_time, end_time]
      end
    end

    expanded
  end

  def overlap?(start1, end1, start2, end2)
    !(end1 <= start2 || end2 <= start1)
  end

  def parse_to_individual_days(days_input)
    return [] unless days_input.present?

    # Normalize input to a single string if it's an array
    days_string = days_input.is_a?(Array) ? days_input.join(", ") : days_input

    days = []
    add_days_to_array(days, days_string)
    days
  end

  def add_days_to_array(days, days_string)
    return unless days_string.present?

    day_patterns = {
      "M" => "M",
      "T" => "T",
      "W" => "W",
      "Th" => "Th",
      "F" => "F"
    }

    # Handle each day pattern
    day_patterns.each do |pattern, day|
      days << day if days_string.include?(pattern)
    end
  end

  def no_duplicate_course_numbers
    return unless courses.present?

    base_codes = courses.map do |course|
      course.base_course_code if course.respond_to?(:base_course_code)
    end.compact

    puts "Base codes in check: #{base_codes.inspect}"

    if base_codes.uniq.length != base_codes.length
      errors.add(:base, "Cannot have multiple sections of the same course")
    end
  end


  def get_course_numbers
    courses.map do |course|
      next unless course.is_a?(Course)
      parts = course.sec_name.split(/[-\s]/)
      parts.take(2).join("-")
    end.compact
  end

  def parse_time_slots(time_slots_input)
    return [] unless time_slots_input.present?

    Array(time_slots_input).map do |slot|
      start_str, end_str = slot.split("-").map(&:strip)
      [Time.parse("2000-01-01 #{start_str} UTC"), Time.parse("2000-01-01 #{end_str} UTC")]
    end
  end
end
