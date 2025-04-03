FactoryBot.define do
  factory :course do
    sequence(:sec_name) { |n| "CSCE #{n}-001" }
    days { "MW" }
    start_time { "9:00 AM" }
    end_time   { "10:20 AM" }
    building { "HLC1" }
    room { "2101" }
    category { "Engineering" }

    trait :math do
      sec_name { "MATH-2413-001" }
      category { "Math" }
      prerequisites { "MATH-2412" }
    end

    trait :science do
      sec_name { "PHYS-2425-001" }
      category { "Science" }
      prerequisites { "MATH-2413" }
    end

    trait :with_prerequisites do
      prerequisites { "MATH-2412" }
    end

    trait :without_prerequisites do
      prerequisites { nil }
    end

    # Newly added

    trait :chem do
      sequence(:sec_name) { |n| "CHEM-1309-#{format('%03d', n)}" }
      days { "MW" }
      start_time { Time.parse("9:00 AM") }
      end_time { Time.parse("10:20 AM") }
      building { "HLC1" }
      room { "2101" }
      category { "Science" }
      prerequisites { nil }
    end

    trait :engr do
      sequence(:sec_name) { |n| "ENGR-102-#{n}" }
      days { "MW" }
      start_time { Time.parse("10:30 AM") }
      end_time { Time.parse("12:20 PM") }
      building { "HLC4" }
      room { "1130.02" }
      category { "Engineering" }
      prerequisites { nil }
    end

    trait :clen do
      sequence(:sec_name) { |n| "CLEN-181-#{n}" }
      days { "M" }
      start_time { Time.parse("12:30 PM") }
      end_time { Time.parse("1:20 PM") }
      building { "HLC4" }
      room { "1130.02" }
      category { "Intro" }
      prerequisites { nil }
    end
  end
end
