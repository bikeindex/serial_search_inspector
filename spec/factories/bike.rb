FactoryBot.define do
  factory :bike do
    sequence(:bike_index_id) { |n| "00#{n}" }
    sequence(:serial) { |n| "KB123 #{n}" }
  end
end
