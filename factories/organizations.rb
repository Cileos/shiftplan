FactoryGirl.define do
  factory :organization do
    account
    sequence(:name) { |i| "#{i.ordinalize} Organization" }
  end
end
