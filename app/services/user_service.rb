# app/services/user_service.rb
class UserService
  def self.process_users_spreadsheet(file)
    spreadsheet = Roo::Excelx.new(file.path)
    users = []
    # Process from row 4 to the last row
    (2..spreadsheet.last_row).each do |row|
      # columns are combined_name, student_id, major, email, active
      row_data = spreadsheet.row(row)
      combined_name = row_data[0]
      student_id    = row_data[1]
      major         = row_data[2]
      email         = row_data[3]
      active        = true
      tamu_uid      = row_data[4]


      # skip rows without email
      next if email.blank?

      # format is last, first middle
      if combined_name.present?
        name_parts = combined_name.split(",")
        last_name  = name_parts[0].strip
        first_name = name_parts[1]&.strip || ""
      else
        last_name  = ""
        first_name = ""
      end

      # Create or update the user
      user = User.find_or_initialize_by(email: email)
      user.assign_attributes(
        first_name: first_name,
        last_name: last_name,
        student_id: student_id,
        major: major,
        role: "student",
        active: active,
        uid: nil,
        provider: nil,
        tamu_uid: tamu_uid
      )
      users << user
    end

    User.import users, on_duplicate_key_update: { conflict_target: [:email], columns: [:first_name, :last_name, :student_id, :major, :active, :role] }
  rescue StandardError => e
    raise "Error processing spreadsheet: #{e.message}"
  end
end
