class Course < ApplicationRecord
  before_validation :normalize_fields
  validates :prerequisites, format: {
    with: /\A(?:|(?:[A-Z]{2,4}(?:[ -])\d{3,4}(?:-(?:\d{1,3}))?(?:,\s*[A-Z]{2,4}(?:[ -])\d{3,4}(?:-(?:\d{1,3}))?)*?))\z/,
    message: "must be a comma-separated list of course codes"
  }, allow_nil: true

  validates :sec_name, presence: true

  validates :sec_name, uniqueness: { scope: [:term, :syn],
    message: "course with this term, department, and syn already exists" }

  def get_prerequisites
    return [] if prerequisites.blank?
    prerequisites.split(",").map(&:strip)
  end

  def base_course_code
    # Standardize format first (replace spaces and slashes with hyphens)
    standardized = sec_name.gsub(/[ \/]/, "-")

    # Extract the first course section and split it into parts
    first_course_part = standardized.split("-").first(2)

    # Return the base course code (e.g., "CHEM-1309" or "PHYS-2425")
    "#{first_course_part[0]}-#{first_course_part[1]}"
  end

  def prerequisite_courses
    get_prerequisites.map { |prereq| Course.find_by(sec_name: prereq) }.compact
  end

  private

  def normalize_fields
    self.sec_name = sec_name.strip if sec_name.present?
    self.term = term.strip if term.present?
    self.syn = syn.strip if syn.present?
  end
end
