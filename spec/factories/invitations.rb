# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invitation do
    token "mytoken"
    sent_at "2012-03-23 12:40:44"
    accepted_at "2012-03-23 12:41:44"
    inviter :factory => :employee
    organization
    employee
  end
end
