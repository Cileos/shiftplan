require 'spec_helper'

describe FeedbackMailer do
  let(:mailer) { described_class.new }
  it "should set reply_to to the submitter's email (for CRM)" do
    address = 'submitter@clockwork.io'
    feedback = double 'Feedback', email: address, name_or_email: 'Name', name: 'Name', browser: 'FF', body: 'putt!'
    
    mail = described_class.notification(feedback)
    mail.from.should == Array(address)
    mail.reply_to.should == Array(address)
  end
end
