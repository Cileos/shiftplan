FactoryGirl.define do
  factory :blog do
    organization
    sequence(:title) { |i| "Blog title #{i.ordinalize}" }
  end
  factory :post do
    blog
    association :author, factory: :employee
    sequence(:title) { |i| "Post title #{i.ordinalize}" }
    sequence(:body)  { |i| "Post body #{i.ordinalize}" }
    published_at { Time.now }
  end
end
