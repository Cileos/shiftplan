FactoryGirl.define do

  factory :notification, class: "Notification::Dummy" do
    employee
  end
end
