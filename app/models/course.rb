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
    # Standardize format first (replace spaces with hyphens)
    standardized = sec_name.gsub(" ", "-")
    parts = standardized.split("-")
    "#{parts[0]}-#{parts[1]}"
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
