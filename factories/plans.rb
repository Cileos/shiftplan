FactoryGirl.define do
  factory :plan do
    sequence(:name) { |i| "Egon's #{i.ordinalize} Plan" }
    sequence(:first_day) { |i| Time.parse('1968-01-01') + i.months }
    organization
  end
end
