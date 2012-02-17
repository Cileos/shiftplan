FactoryGirl.define do
  factory :plan do
    sequence(:name) { |i| "Egon's #{i.ordinalize} Plan" }
    organization
  end

  factory :scheduling do
    plan
    employee
    sequence(:starts_at) {|i| Time.zone.parse('1968-01-01') + i.hours }
    sequence(:ends_at) {|i| Time.zone.parse('1968-01-01') + (i + 2).hours }
    week 1
    year 1968
  end

  factory :manual_scheduling, class: 'Scheduling' do
    # starts_at and ends_at must be calculated
    plan
    employee
    sequence(:week)  { |i| i % 52 }
    sequence(:cwday) { |i| i % 6 }
    year             2011
    quickie          '9-17'
  end
end
