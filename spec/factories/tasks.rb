# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task do
    name "MyString"
    milestone_id ""
    due_at "2012-09-10 15:31:48"
    done false
  end
end
