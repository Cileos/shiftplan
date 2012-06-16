# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :email_change do
    user_id 1
    email "MyString"
  end
end
