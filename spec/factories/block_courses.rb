FactoryBot.define do
  factory :block_course do
    association :block_selection
    association :course
  end
end
