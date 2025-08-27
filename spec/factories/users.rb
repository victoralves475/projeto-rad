FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@test.com" }
    password { "123456" }
  end
end
