describe Notification::UpcomingScheduling do

  let(:scheduling) do
    build(:scheduling, employee: build(:employee, user: build(:user)))
  end
  let(:subject) do
    described_class.new(notifiable: scheduling, employee: scheduling.employee)
  end

  context "on create" do
    it "sends an upcoming scheduling mail" do
      mail = instance_double('Mail::Message')
      UpcomingSchedulingNotificationMailer.should_receive(:upcoming_scheduling).with(subject).and_return(mail)
      mail.should_receive(:deliver)

      subject.save!
    end
  end
end
