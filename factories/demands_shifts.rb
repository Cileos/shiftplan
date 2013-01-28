# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :demands_shift, :class => 'DemandsShifts' do
    demand
    shift
  end
end
