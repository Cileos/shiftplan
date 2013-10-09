FactoryGirl.define do

  factory :notification, class: "Notification::Dummy" do
    employee
  end

  factory :post_notification, class: "Notification::Post" do
    employee
    association :notifiable, factory: :post
  end

  factory :upcoming_scheduling_notification, class: 'Notification::UpcomingScheduling' do
    employee
    association :notifiable, factory: :upcoming_scheduling_in_the_next_24_hours
  end
end
