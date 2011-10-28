FactoryGirl::Password = 'secret'

FactoryGirl.define do
  factory :user do
    sequence(:email) { |i| "user-#{i}@example.com" }
    password FactoryGirl::Password
    password_confirmation FactoryGirl::Password

    factory :confirmed_user do
      after_create { |u| u.confirm! }
    end
  end
end
