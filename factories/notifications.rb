FactoryGirl.define do

  factory :notification, class: "Notification::Dummy" do
    employee
  end

  factory :sent_notification, parent: :notification do
    sequence(:sent_at) { 1.day.ago }
  end
end
