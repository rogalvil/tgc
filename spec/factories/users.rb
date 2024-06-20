FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user-#{n}@example.com" }
    name { 'John Doe' }
    password { '12345678' }
    password_confirmation { '12345678' }

    trait :with_invalid_name do
      name { '3294{}+{-}' }
    end

    trait :admin do
      role { 'admin' }
    end
  end
end
