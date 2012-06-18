unless defined?(FactoryGirl::Password)
  FactoryGirl::Password = 'secret'
end

FactoryGirl.define do
  factory :user do
    sequence(:email) { |i| "user-#{i}@example.com" }
    password FactoryGirl::Password
    password_confirmation FactoryGirl::Password

    factory :confirmed_user do
      after_create { |u| u.confirm! }

      factory :confirmed_user_with_employee do
        after_create { |u| Factory :employee, user: u }
      end
    end
  end
end
