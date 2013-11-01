describe NotificationPurger do

  context ".purge!" do

    it "purges notifications older than 3 months" do
      post_notification     = create(:post_notification, created_at: (3.months.ago + 1.day))
      old_post_notification = create(:post_notification, created_at: (3.months.ago - 1.day))

      NotificationPurger.purge!

      Notification::Base.find_by_id(old_post_notification.id).should be_nil
      Notification::Base.find_by_id(post_notification.id).should_not be_nil
    end

    it "purges upcoming scheduling notifications with scheduling that ended already" do
      now = Time.zone.now
      scheduling_of_the_past         = create(:scheduling, starts_at: now - 8.hours, ends_at: now - 5.minutes)
      outdated_upcoming_notification = create(:upcoming_scheduling_notification, notifiable: scheduling_of_the_past)
      upcoming_notification          = create(:upcoming_scheduling_notification)

      NotificationPurger.purge!

      Notification::Base.find_by_id(outdated_upcoming_notification.id).should be_nil
      Notification::Base.find_by_id(upcoming_notification.id).should_not be_nil
    end
  end
end
