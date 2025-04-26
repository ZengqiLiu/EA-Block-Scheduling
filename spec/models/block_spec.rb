require 'rails_helper'

RSpec.describe Block, type: :model do
  describe "validations" do
    let(:science_course) { create(:course, sec_name: 'PHYS 101-001', category: 'Science') }
    let(:math_course) { create(:course, sec_name: 'MATH 101-001', category: 'Math') }
    let(:engineering_course) { create(:course, sec_name: 'ENGR 101-001', category: 'Engineering') }
    let(:other_course) { create(:course, sec_name: 'CLEN 101-001', category: 'Other') }


    it "validates no time conflicts" do
      course1 = create(:course, sec_name: 'MATH 102-001', category: 'Math',
                      days: "MW", start_time: "9:00 AM", end_time: "10:00 AM")
      course2 = create(:course, sec_name: 'PHYS 102-001', category: 'Science',
                      days: "MW", start_time: "9:30 AM", end_time: "10:30 AM")
      course3 = create(:course, sec_name: 'ENGR 102-001', category: 'Engineering',
                      days: "TTH", start_time: "9:00 AM", end_time: "10:00 AM")
      course4 = create(:course, sec_name: 'CLEN 102-001', category: 'Other',
                      days: "TTH", start_time: "10:30 AM", end_time: "11:30 AM")

      block = Block.new([course1, course2, course3, course4])
      expect(block).not_to be_valid
      expect(block.errors[:base]).to include(/Time conflict between/)
    end

    it "validates no duplicate course numbers" do
      course1 = create(:course, sec_name: "MATH 101-001", category: 'Math')
      course2 = create(:course, sec_name: "MATH 101-002", category: 'Math')
      course3 = create(:course, sec_name: "PHYS 101-001", category: 'Science')
      course4 = create(:course, sec_name: "ENGR 101-001", category: 'Engineering')
      block = Block.new([course1, course2, course3, course4])
      expect(block).not_to be_valid
      expect(block.errors[:base]).to include("Cannot have multiple sections of the same course")
    end
  end

  describe ".generate_blocks" do
    let!(:course1) { create(:course, sec_name: "MATH-101-001", category: "Math", days: "MW", start_time: "9:00 AM", end_time: "10:00 AM") }
    let!(:course2) { create(:course, sec_name: "PHYS-101-001", category: "Science", days: "TTH", start_time: "9:00 AM", end_time: "10:00 AM") }
    let!(:course3) { create(:course, sec_name: "ENGR-101-001", category: "Engineering", days: "MW", start_time: "10:30 AM", end_time: "11:30 AM") }
    let!(:duplicate_course) { create(:course, sec_name: "MATH-101-002", category: "Math", days: "MW", start_time: "11:00 AM", end_time: "12:00 PM") }

    it "returns valid blocks without duplicate base courses" do
      courses = [course1, course2, course3]

      blocks = Block.generate_blocks(courses)

      expect(blocks).to all(be_a(Block))
      expect(blocks.size).to eq(1)
      expect(blocks.first.courses).to match_array([course1, course2, course3])
    end

    it "ignores duplicate base course sections" do
      courses = [course1, course2, course3, duplicate_course]

      blocks = Block.generate_blocks(courses)

      expect(blocks).to all(be_a(Block))
      expect(blocks.size).to eq(1)
      expect(blocks.first.courses.map(&:base_course_code).uniq.length).to eq(3)
    end

    it "returns empty when given an empty course list" do
      blocks = Block.generate_blocks([])
      expect(blocks).to eq([])
    end

    it "returns empty when no valid combinations exist (due to time conflict)" do
      bad_course = create(:course, sec_name: "PHYS-101-002", category: "Science", days: "MW", start_time: "9:30 AM", end_time: "10:30 AM")

      courses = [course1, bad_course]

      blocks = Block.generate_blocks(courses)

      expect(blocks).to eq([])
    end
  end
end
