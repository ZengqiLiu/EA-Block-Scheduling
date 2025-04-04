require 'rails_helper'

RSpec.describe BlockSelection, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:block_courses).dependent(:destroy) }
    it { should have_many(:courses).through(:block_courses) }
  end

  describe 'dependent destroy' do
    it 'destroys associated block_courses when block_selection is destroyed' do
      block_selection = FactoryBot.create(:block_selection)
      FactoryBot.create(:block_course, block_selection: block_selection)
      expect { block_selection.destroy }.to change { BlockCourse.count }.by(-1)
    end
  end
end
