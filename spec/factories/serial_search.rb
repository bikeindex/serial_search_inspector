FactoryGirl.define do
  factory :serial_search do
    sequence(:serial) { |n| "125.0.69.#{n}" }
  end
end
