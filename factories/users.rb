unless defined?(FactoryGirl::Password)
  FactoryGirl::Password = 'secret'
end

FactoryGirl.define do
  factory :user do
    sequence(:email) { |i| "user-#{i}@example.com" }
    password FactoryGirl::Password
    password_confirmation FactoryGirl::Password

    factory :confirmed_user do
      after(:create) { |u| u.confirm! }

      factory :confirmed_user_with_employee do
        after(:create) { |u| FactoryGirl.create :employee, user: u }
      end
    end

    factory :owner # of Account

    locale 'de'
  end
end
