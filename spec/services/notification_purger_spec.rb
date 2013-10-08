describe NotificationPurger do

  context ".purge!" do

    let!(:old_post_notification) do
      create(:post_notification, created_at: (3.months.ago - 5.minute))
    end
    let!(:post_notification) do
      create(:post_notification, created_at: (3.months.ago + 5.minute))
    end

    let!(:scheduling_of_the_past) do
      now = Time.zone.now
      create(:scheduling, starts_at: now - 8.hours, ends_at: now - 5.minute)
    end
    let!(:outdated_upcoming_notification) do
      create(:upcoming_scheduling_notification, notifiable: scheduling_of_the_past)
    end
    let!(:upcoming_notification) do
      create(:upcoming_scheduling_notification)
    end

    it "purges 2 of 4" do
      expect do
        NotificationPurger.purge!
      end.to change(Notification::Base, :count ).from(4).to(2)
    end

    it "purges notifications older than 3 months" do
      NotificationPurger.purge!

      Notification::Base.find_by_id(old_post_notification.id).should be_nil
      Notification::Base.find_by_id(post_notification.id).should_not be_nil
    end

    it "purges upcoming scheduling notifications with scheduling that ended already" do
      NotificationPurger.purge!

      Notification::Base.find_by_id(outdated_upcoming_notification.id).should be_nil
      Notification::Base.find_by_id(upcoming_notification.id).should_not be_nil
    end
  end
end
