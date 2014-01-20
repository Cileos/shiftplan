describe NotificationDestroyer do

  let(:destroyer)     { described_class.new(notifiable) }
  let(:employee)      { create :employee }
  let(:notifiable)    { create :post }
  let!(:notification) { create :post_notification, notifiable: notifiable }

  context "#destroy!" do

    it "destroys all notifications of the notifiable" do
      expect do
        destroyer.destroy!
      end.to change { Notification::Post.count }.from(1).to(0)
    end

  end
end
