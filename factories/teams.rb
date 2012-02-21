# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :team do
    sequence(:name) { |i| "Team #{i}" }
  end
end
