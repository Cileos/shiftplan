FactoryGirl.define do
  factory :post do
    published_at { Time.now }
  end
end