# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shift do
    plan_template
    sequence(:starts_at) {|i| Time.zone.parse('1968-01-01') + i.hours }
    sequence(:ends_at) {|i| Time.zone.parse('1968-01-01') + (i + 2).hours }
    day 1
    team
  end
end
