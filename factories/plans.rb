FactoryGirl.define do
  factory :plan do
    sequence(:name) { |i| "Egon's #{i.ordinalize} Plan" }
    sequence(:first_day) { |i| Time.zone.parse('1968-01-01') + i.months }
    organization
  end

  factory :scheduling do
    plan
    employee
    sequence(:starts_at) {|i| Time.zone.parse('1968-01-01') + i.hours }
    sequence(:ends_at) {|i| Time.zone.parse('1968-01-01') + (i + 2).hours }
  end
end
