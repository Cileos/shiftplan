FactoryGirl.define do
  factory :employee do
    account
    sequence(:first_name) { |i| "Bart #{i.ordinalize}" } # should be #romanize (Bart the III.)
    last_name 'Simpson'
    role ''
    force_create_duplicate "1"

    factory :employee_planner do
      role 'planner'
    end

    factory :employee_owner do
      role 'owner'
    end
  end
end
