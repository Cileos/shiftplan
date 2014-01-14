require 'spec_helper'

describe NotificationCreator do

  let(:notifiable) { double('Notifiable') }
  let(:creator)    { described_class.new notifiable }

  let(:homer_simpson)          { double('Homer Simpson') }
  let(:bart_simpson)           { double('Bart Simpson') }
  let(:recipients)             { [homer_simpson, bart_simpson] }
  let(:klass_1)                { double('Some notification class') }
  let(:klass_2)                { double('Another notification class') }

  shared_examples :each_notification_creator do
    it "creates expected notifications and delivers an email for each of them" do
      recipients_finder.stub(:[]).with(notifiable).and_return(recipients)

      klass_finder.stub(:[]).with(notifiable, homer_simpson).and_return(klass_1)
      klass_finder.stub(:[]).with(notifiable, bart_simpson).and_return(klass_2)

      klass_1.should_receive(:create!).with(notifiable: notifiable, employee: homer_simpson).
        and_return(notification_1 = instance_double("Notification::Base"))
      klass_2.should_receive(:create!).with(notifiable: notifiable, employee: bart_simpson).
        and_return(notification_2 = instance_double("Notification::Base"))

      notification_1.should_receive(:send_mail)
      notification_2.should_receive(:send_mail)

      creator.create!
    end
  end

  context "#create!" do

    context "without options for recipients and klass finder" do
      let(:recipients_finder_mock) { double('RecipientsFinder') }
      let(:klass_finder_mock)      { double('KlassFinder') }

      before(:each) do
        Volksplaner.stub(:notification_recipients_finder => recipients_finder_mock)
        Volksplaner.stub(:notification_klass_finder => klass_finder_mock)
      end

      it_behaves_like :each_notification_creator do
        let(:recipients_finder)  { recipients_finder_mock}
        let(:klass_finder)       { klass_finder_mock}
      end
    end

    context "with options for recipients and klass finder" do

      let(:creator) do
        described_class.new(notifiable,
          recipients_finder: special_recipients_finder,
          klass_finder: special_klass_finder)
      end

      let(:special_recipients_finder) { double('Special recipients finder') }
      let(:special_klass_finder)      { double('Special klass finder') }

      it_behaves_like :each_notification_creator do
        let(:recipients_finder)  { special_recipients_finder}
        let(:klass_finder)       { special_klass_finder }
      end
    end

  end
end
