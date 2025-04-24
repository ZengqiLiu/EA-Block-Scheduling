module CoursesHelper
  def validate_courses(id)
    as_id = id.to_i
    return if Course.exists?(as_id: as_id)
    flash[:error] = "Courses not found: #{as_id}"
  end

  def get_prerequisite_names(prerequisites)
    return "None" if prerequisites.blank?

    prerequisites.split(",").map do |prereq|
      prereq.strip
    end.uniq.join(", ")
  end

  # Gets the course code from the sec_name (e.g. MATH-2414 from MATH-2414-007)
  def extract_base_code(sec_name)
    standardized = sec_name.gsub(" ", "-")
    parts = standardized.split("-")
    "#{parts[0]}-#{parts[1]}"
  end

  # Get type of course from sec_name using extract_base_code (e.g. MATH from MATH-2414-007)
  def extract_type(sec_name)
    base_code = extract_base_code(sec_name)
    parts = base_code.split("-")
    parts[0]
  end

  # Define prereqs and coreqs for listed courses for populating columns during creation

  def corequisites
    {
      "ENGR-216"  => ["PHYS-2425"],
      "ENGR-217"  => ["PHYS-2426"],
      "PHYS-2425" => ["MATH-2414"],
      "PHYS-2426" => ["MATH-2415"]
    }
  end


  def prerequisites
    {
      "ENGR-102"    => [],
      "CLEN-181"    => [],
      "CLEN-261"    => [],
      "CHEM-1309"   => [],
      "CHEM-1109"   => [],
      "CHEM-1311"   => [],
      "CHEM-1111"   => [],
      "CHEM-1312"   => ["CHEM-1311"],
      "CHEM-1112"   => ["CHEM-1111"],
      "MATH-2413"   => ["MATH-2412"],
      "MATH-2414"   => ["MATH-2413"],
      "MATH-2415"   => ["MATH-2414"],
      "MATH-2420"   => ["MATH-2415"],
      "ENGR-216"    => ["ENGR-102", "MATH-2413"],  # (MATH-2413 or higher)
      "ENGR-217"    => ["ENGR-216", "PHYS-2425", "MATH-2414"], # assumes prereqs not coreqs
      "PHYS-2425"   => ["MATH-2413"],  # co-enroll in MATH-2414 not enforced here
      "PHYS-2426"   => ["PHYS-2425", "MATH-2414"] # assumes co-enrolled in MATH-2415
    }
  end


  # Define categories of courses based on class code
  def categories
    {
      "MATH" => "Math",
      "PHYS" => "Science",
      "CHEM" => "Science",
      "ENGR" => "Engineering",
      "CLEN" => "Intro"
    }
  end

  def distinct_courses_by_dept(dept_code)
    Course.where("dept_code LIKE ?", "#{dept_code}%")
          .group_by { |c| extract_base_code(c.sec_name) }
          .map { |base, records| ["#{base} - #{records.first.short_title}", base] }
  end
end
