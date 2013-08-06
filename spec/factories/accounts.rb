# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
    sequence(:name) { |i| "The #{i.ordinalize} Account GmbH" }
  end

  factory :new_account, parent: :account do
    on_new_account true
    sequence(:organization_name) { |i| "Organization#{i}" }
    sequence(:first_name) { |i| "Bart #{i.ordinalize}" }
    last_name 'Simpson'
    user_id { create(:user).id }
  end
end
