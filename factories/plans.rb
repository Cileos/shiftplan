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

    factory :upcoming_scheduling_in_the_next_24_hours do
      starts_at { Time.zone.now + 23.hours }
      ends_at   { Time.zone.now + 30.hours }
    end
  end

  factory :manual_scheduling, class: 'Scheduling' do
    # starts_at and ends_at must be calculated
    plan
    employee
    sequence(:week)  { |i| 1 + (i % 51) }
    sequence(:cwday) { |i| 1 + (i % 7) }
    year             2011
    quickie          '9-17'
  end

  factory :scheduling_by_quickie, class: 'Scheduling' do
    quickie '9-17'
    plan
    employee
    date { Date.today }
    after :build do |s|
      s.valid?
    end
  end
end
