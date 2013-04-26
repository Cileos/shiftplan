# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shift do
    plan_template
    start_hour 9
    start_minute 0
    end_hour 17
    end_minute 0
    day 1
    team
  end
end
