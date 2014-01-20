require 'spec_helper'

describe SchedulingNotificationMailer do
  let(:author)  do
    create(:employee, first_name: "Bart", user: create(:confirmed_user))
  end
  let(:recipient) do
    create(:employee, first_name: "Lisa",
      user: create(:confirmed_user, email: "homer@thesimpsons.com"))
  end
  let(:scheduling) do
    build_without_dates({
      employee: recipient,
      date:       '1988-05-05' ,
      start_hour: 9,
      end_hour:   17
    }).tap(&:save!)
  end
  let!(:comment) { Comment.build_from(scheduling, author, body: "Mein Senf dazu!").tap(&:save!) }
  let(:mail) { described_class.new_comment(notification) }
  let(:notification) do
    Notification::CommentOnSchedulingOfEmployee.create!(
      employee: recipient,
      notifiable: comment)
  end

  it "sender address is no-reply@" do
    mail.from.first.should =~ /^no-reply@.*clockwork.io$/
  end

  it "recipient address is the email of the scheduled employee" do
    mail.to.size.should == 1
    mail.to.first.should =~ /^homer@thesimpsons.com$/
  end

  it "has a correct subject" do
    mail.subject.should == "Bart Simpson hat eine Ihrer Schichten kommentiert"
  end

  context "body" do

    it "includes a salutation" do
      mail.body.should include("Hallo Lisa Simpson!")
    end

    it "includes the comment's body" do
      mail.body.should include("Mein Senf dazu!")
    end

    it "includes information about the commented scheduling" do
      mail.body.should include("Bart Simpson hat eine Ihrer Schichten am Donnerstag, 05.05.1988 (9-17) kommentiert")
    end
  end

end
