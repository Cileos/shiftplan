FactoryGirl.define do

  factory :notification, class: "Notification::Dummy" do
    employee

    factory :post_notification, class: "Notification::Post" do
      association :notifiable, factory: :post
    end

    factory :comment_on_post_of_employee_notification, class: "Notification::CommentOnPostOfEmployee" do
      association :notifiable, factory: :comment
    end

    factory :upcoming_scheduling_notification, class: 'Notification::UpcomingScheduling' do
      association :notifiable, factory: :upcoming_scheduling_in_the_next_24_hours
    end
  end
end
