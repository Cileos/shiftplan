describe Notification::Base do

  context "#deliver!" do

    let(:notification)  { Notification::Base.new(employee: employee) }
    let(:employee)      { build(:employee, user: user) }
    let(:mailer_class)  { double('Mailer') }

    before(:each) do
      notification.class.stub(:mailer_class).and_return(mailer_class)
      notification.class.stub(:mailer_action).and_return(:my_mailer_action)
    end

    context "when the user has notification emails turned off" do

      let(:user) { build(:user, receive_notification_emails: false) }

      it "does not deliver an email" do
        mailer_class.should_receive(:my_mailer_action).never

        notification.send(:deliver!)
      end
    end

    context "when the user has notification emails turned on" do

      let(:user) { build(:user, receive_notification_emails: true) }

      it "delivers an email" do
        mail = double('Mail')
        mailer_class.should_receive(:my_mailer_action).once.and_return(mail)
        mail.should_receive(:deliver)

        notification.send(:deliver!)
      end
    end
  end
end
