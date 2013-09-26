require 'spec_helper'
require 'volksplaner/staging_mail_interceptor'

describe Volksplaner::StagingMailInterceptor do
  before :each do
    Mail.register_interceptor(described_class)
  end
  after :each do
    Mail.send(:class_variable_get, :@@delivery_interceptors).delete(described_class)
  end

  let(:feedback) do
    double('Feedback', email: 'bart.simpson@springfield.com',
      name_or_email: 'Bart Simpson', name: 'Bart Simpson', browser: 'FF', body: 'putt!')
  end

  let(:mail) do
    FeedbackMailer.notification(feedback).deliver
  end

  context "when recipient is included in the whitelist of intercepted mail addresses" do
    it "performs the delivery of the mail" do
      expect { mail }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it "sends the mail to the mailing list" do
      mail.to.should include('staging@clockwork.io')
    end

    it "mentions the original recipient in X-Intercepted-To header" do
      mail.header.field_summary.should =~ /X-Intercepted-To: support@app.clockwork.io/
    end
  end

  context "when recipient is not included in whitelist of intercepted mail addresses" do
    before(:each) do
      Volksplaner::StagingMailInterceptor.stub(:intercepted_mail_addresses).
        and_return(['test@blubber.com'])
    end

    it "does not perform the delivery of the mail" do
      expect { mail }.not_to change(ActionMailer::Base.deliveries, :count)
    end

    it "does not change the recipients of the mail" do
      mail.to.should == ['support@app.clockwork.io']
    end
  end

end
