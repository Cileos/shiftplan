describe UpcomingSchedulingNotificationMailer do

  let(:mr_burns) do
    create(:mr_burns)
  end
  let(:notification) do
    create(:upcoming_scheduling_notification, employee: mr_burns.employees.first)
  end
  let(:mail) do
    described_class.upcoming_scheduling(notification)
  end


  context "#upcoming_scheduling" do
    it "has the clockwork no reply email address in the senders list" do
      mail.from.should == [ 'no-reply@app.clockwork.io' ]
    end

    it "has mr burns' email address in the recipients list" do
      mail.to.should == [ 'c.burns@npp-springfield.com' ]
    end

  end
end
