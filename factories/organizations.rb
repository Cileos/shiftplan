FactoryGirl.define do
  factory :organization do
    sequence(:name) { |i| "#{i.ordinalize} Organization" }
  end
end
