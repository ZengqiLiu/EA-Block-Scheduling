require 'rails_helper'

RSpec.describe BlockCourse, type: :model do
  describe 'associations' do
    it { should belong_to(:block_selection) }
    it { should belong_to(:course) }
  end

  describe 'validations' do
    subject { FactoryBot.build(:block_course) }

    it 'is valid with valid associations' do
      expect(subject).to be_valid
    end

    it 'is invalid without a block_selection' do
      subject.block_selection = nil
      expect(subject).not_to be_valid
    end

    it 'is invalid without a course' do
      subject.course = nil
      expect(subject).not_to be_valid
    end
  end
end
