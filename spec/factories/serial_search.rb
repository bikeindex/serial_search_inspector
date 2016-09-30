FactoryGirl.define do
  factory :serial_search do
    sequence(:serial) { |n| "KB123 5346 #{n}" }
  end
end
