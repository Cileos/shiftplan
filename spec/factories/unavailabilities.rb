# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :unavailability do
    starts_at "2014-03-21 14:38:18"
    ends_at "2014-03-21 14:38:18"
  end

  factory :unavailability_by_quickie, class: 'Unavailability' do
    quickie '9-17'
    date { Date.today }
    after :build do |s|
      s.valid?
    end
  end
end
