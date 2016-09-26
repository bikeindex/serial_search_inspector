FactoryGirl.define do
  factory :ip_address do
    sequence(:address) { |n| '125.0.69.#{n}' }
  end
end
