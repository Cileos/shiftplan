FactoryGirl.define do
  factory :qualification do
    sequence(:name) { |i| "Qualification #{i}" }
    organization
  end
end
