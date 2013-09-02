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

  it "intercepts mails to always be sent to the mailing list" do
    mail.to.should include('develop@clockwork.io')
  end

  it "mentiones the original recipient in X-Intercepted-To header" do
    mail.header.field_summary.should =~ /X-Intercepted-To: support@app.clockwork.io/
  end
end
