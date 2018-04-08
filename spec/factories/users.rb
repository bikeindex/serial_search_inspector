FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password 'some_pass69'
    factory :superuser do
      superuser true
    end
  end
end
