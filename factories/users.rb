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

      factory :planner do
        roles %w(planner)
      end
    end
  end
end
