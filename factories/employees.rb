FactoryGirl.define do
  factory :employee do
    account
    sequence(:first_name) { |i| "Bart #{i.ordinalize}" } # should be #romanize (Bart the III.)
    last_name 'Simpson'
    role ''
    force_duplicate "1"

    factory :employee_owner do
      after(:create) do |e|
        account = e.account
        account.owner_id = e.id
        account.save!
      end
    end
  end
end
