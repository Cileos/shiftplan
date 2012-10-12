# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
    sequence(:name) { |i| "Account#{i} GmbH" }
  end
end
