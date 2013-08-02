unless defined?(FactoryGirl::Password)
  FactoryGirl::Password = 'secret'
end

FactoryGirl.define do
  factory :user do
    sequence(:email) { |i| "user-#{i}@example.com" }
    password FactoryGirl::Password
    password_confirmation FactoryGirl::Password
    locale 'de'

    factory :confirmed_user do
      after(:create) { |u| u.confirm! }

      factory :confirmed_user_with_employee do
        after(:create) { |u| FactoryGirl.create :employee, user: u }
      end

      factory :mr_burns do
        email 'c.burns@npp-springfield.com'

        after(:create) do |u|
          springfield = FactoryGirl.create(:account,
            name: 'Springfield Nuclear Power Plant')
          mr_burns = FactoryGirl.create(:employee_owner,
            first_name: 'Charles',
            last_name: 'Burns',
            account: springfield,
            user: u)
          sector_7_g = FactoryGirl.create(:organization,
            name: 'Sector 7-G',
            account: springfield)
          FactoryGirl.create(:membership,
            employee: mr_burns,
            organization: sector_7_g)
        end
      end
    end
  end
end
