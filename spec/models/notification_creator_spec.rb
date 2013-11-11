require 'spec_helper'

describe NotificationCreator do

  let(:notifiable) { double('Notifiable') }
  let(:creator)    { described_class.new notifiable }

  let(:recipients_finder_mock) { double('RecipientsFinder') }
  let(:klass_finder_mock)      { double('KlassFinder') }
  let(:homer_simpson)          { double('Homer Simpson') }
  let(:bart_simpson)           { double('Bart Simpson') }
  let(:recipients)             { [homer_simpson, bart_simpson] }
  let(:klass_1)                { double('Some notification class') }
  let(:klass_2)                { double('Another notification class') }


  context "#create!" do

    context "without options for recipients and klass finder" do

      it "creates notifications of the right type for each recipient with default finders" do
        Volksplaner.stub(:notification_recipients_finder => recipients_finder_mock)
        recipients_finder_mock.stub(:[]).with(notifiable).and_return(recipients)

        Volksplaner.stub(:notification_klass_finder => klass_finder_mock)
        klass_finder_mock.stub(:[]).with(notifiable, homer_simpson).and_return(klass_1)
        klass_finder_mock.stub(:[]).with(notifiable, bart_simpson).and_return(klass_2)

        klass_1.should_receive(:create!).with(notifiable: notifiable, employee: homer_simpson)
        klass_2.should_receive(:create!).with(notifiable: notifiable, employee: bart_simpson)

        creator.create!
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

      it "creates notifications of the right type for each recipient with the specified finders" do
        special_recipients_finder.stub(:[]).with(notifiable).and_return(recipients)

        special_klass_finder.stub(:[]).with(notifiable, homer_simpson).and_return(klass_1)
        special_klass_finder.stub(:[]).with(notifiable, bart_simpson).and_return(klass_2)

        klass_1.should_receive(:create!).with(notifiable: notifiable, employee: homer_simpson)
        klass_2.should_receive(:create!).with(notifiable: notifiable, employee: bart_simpson)

        creator.create!
      end

    end

  end
end
