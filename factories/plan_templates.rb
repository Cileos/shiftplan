FactoryGirl.define do
  factory :plan_template do
    sequence(:name) { |i| "Plan Template #{i}" }
    template_type 'weekbased'
    organization
  end
end
