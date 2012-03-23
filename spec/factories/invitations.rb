# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invitation do
    invitation_token "MyString"
    invitation_sent_at "2012-03-23 12:40:44"
    invitation_accepted_at "2012-03-23 12:40:44"
    invited_by_id 1
    organization_id 1
    employee_id 1
    user_id 1
  end
end
