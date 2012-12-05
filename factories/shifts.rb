# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shift do
    plan_template
    start_hour 1
    end_hour 1
    start_minute 1
    end_minute 1
    team
  end
end
