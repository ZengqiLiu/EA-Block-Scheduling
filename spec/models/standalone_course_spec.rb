require 'rails_helper'

RSpec.describe StandaloneCourse, type: :model do
  before(:all) do
    @user = User.find_by(email: 'student@example.com') || User.create!(
      email: 'student@example.com',
      first_name: 'Test',
      last_name: 'Student',
      role: 'student',
      uid: 'test-uid',
      provider: 'google'
    )

    @course = Course.find_by(sec_name: 'CHEM-1309-001') || Course.create!(
      term: '224F000',
      dept_code: 'CHEM',
      course_id: '517302',
      sec_coreq_secs: '517302',
      syn: '93061',
      sec_name: 'CHEM-1309-001',
      short_title: 'Gen Chem Engr Lc',
      im: 1,
      building: 'HLC1',
      room: '2101',
      days: 'MW',
      start_time: '9:00 AM',
      end_time: '10:20 AM',
      crs_capacity: 36,
      sec_cap: 0,
      student_count: 0,
      notes: ''
    )

    @standalone_course = StandaloneCourse.find_by(user: @user, course: @course) || StandaloneCourse.create!(
      user: @user,
      course: @course
    )
  end

  describe "Record existence" do
    it "includes the created standalone course" do
      expect(StandaloneCourse.all).to include(@standalone_course)
    end
  end

  describe "Associations" do
    it "belongs to a user" do
      expect(@standalone_course.user).to eq(@user)
    end

    it "belongs to a course" do
      expect(@standalone_course.course).to eq(@course)
    end
  end
end
