FactoryGirl.define do
  factory :blog do
    sequence(:title) { |i| "Blog title #{i.ordinalize}" }
  end
  factory :post do
    sequence(:title) { |i| "Post title #{i.ordinalize}" }
    sequence(:body)  { |i| "Post body #{i.ordinalize}" }
    published_at { Time.now }
  end
end