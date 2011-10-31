FactoryGirl.define do
  factory :employee do
    sequence(:first_name) { |i| "Bart #{i.ordinalize}" } # should be #romanize (Bart the III.)
    last_name 'Simpson'
  end
end
