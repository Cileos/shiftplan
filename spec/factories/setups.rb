# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :setup do
    employee_first_name 'James'
    employee_last_name 'Bond'
    user
  end
end
