# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :membership do
    organization
    employee
    organization_weekly_working_time "9.99"
  end
end
