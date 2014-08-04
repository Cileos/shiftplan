require 'spec_helper'

describe Notification::Base do

  context "#send_mail" do

    shared_examples :a_notification_not_sending_an_email do
      it "does not deliver an email" do
        mailer_class.should_receive(:my_mailer_action).never

        notification.send_mail
      end
    end

    let(:notification)  { Notification::Base.create(employee: employee, type: 'Notification::Base') }
    let(:employee)      { build(:employee, user: user) }
    let(:mailer_class)  { double('Mailer') }

    before(:each) do
      notification.class.stub(:mailer_class).and_return(mailer_class)
      notification.class.stub(:mailer_action).and_return(:my_mailer_action)
    end

    context "when the employee does not have a user" do
      it_behaves_like :a_notification_not_sending_an_email do
        let(:user) { nil }
      end
    end

    context "when the user has notification emails turned off" do
      it_behaves_like :a_notification_not_sending_an_email do
        let(:user) { build(:user, receive_notification_emails: false) }
      end
    end

    context "when the user has notification emails turned on" do
      let(:user) { build(:user, receive_notification_emails: true) }
      let(:mail) { mail = double('Mail') }

      before(:each) do
        mailer_class.should_receive(:my_mailer_action).once.and_return(mail)
      end

      it "delivers an email" do
        mail.should_receive(:deliver)

        notification.send_mail
      end

      it "sets the timestamp" do
        mail.stub(:deliver)
        Timecop.freeze(Time.parse('2012-12-12 12:23:00'))

        expect { notification.send_mail }.to change(notification, :sent_at).from(nil).to(Time.zone.now)
      end
    end
  end

  context '#mark_as_read!' do
    let(:notification) { create :notification }

    it 'marks unread notification as read' do
      notification.read_at.should be_nil
      notification.mark_as_read!
      notification.read_at.should_not be_nil
    end

    it 'marks unread notification as seen' do
      expect do
        notification.mark_as_read!
      end.to change { notification.seen? }.from(false).to(true)
    end

    it 'saves the notification' do
      notification.mark_as_read!
      notification.should_not be_changed # all saved
    end

    it 'is idempotent' do
      notification.mark_as_read!
      expect { notification.mark_as_read! }.not_to raise_error
    end
  end
end
