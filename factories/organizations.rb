FactoryGirl.define do
  factory :organization do
    account
    sequence(:name) { |i| "The #{i.ordinalize} Organization" }
  end
end
