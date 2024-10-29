class Course < ApplicationRecord
  validates :prerequisites, format: {
    with: /\A([A-Z]{4}-\d{4}(,\s*[A-Z]{4}-\d{4})*)?$\z/,
    message: "must be a comma-separated list of course codes (e.g., 'MATH-2413, PHYS-2425')",
    allow_blank: true
  }

  def prerequisite_courses
    return [] if prerequisites.blank?
    Course.where(course: prerequisites.split(",").map(&:strip))
  end

  def prerequisites_met?(completed_courses)
    prerequisite_courses.all? { |prereq| completed_courses.include?(prereq.course) }
  end

  def get_prerequisites
    return [] if prerequisites.blank?

    prerequisites.split(",").map(&:strip)
  end
end
