# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :email_change do
    association :user, factory: :confirmed_user_with_employee
    sequence(:email) { |i| "user-#{i}@example.com" }
  end
end
