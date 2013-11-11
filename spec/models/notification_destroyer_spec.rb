describe NotificationDestroyer do

  let(:destroyer)       { described_class.new(notifiable) }
  let(:notifiable)      { double('Some notifiable') }
  let(:notification_1)  { instance_double('Notification::Base') }
  let(:notification_2)  { instance_double('Notification::Base') }
  let(:notifications)   { [notification_1, notification_2] }

  context "#destroy!" do

    it "destroys all notifications of the notifiable" do
      Notification::Base.stub(:by_notifiable).with(notifiable).
        and_return(notifications)
      notification_1.should_receive(:destroy)
      notification_2.should_receive(:destroy)

      destroyer.destroy!
    end

  end
end
