# encoding: utf-8

describe UpcomingSchedulingNotificationMailer do

  let(:mr_burns) do
    create(:mr_burns, locale: nil)
  end
  let(:employee_mr_burns) do
    mr_burns.employees.first
  end
  let(:organization) do
    employee_mr_burns.organizations.first
  end
  let(:scheduling) do
    create(:scheduling,
      starts_at: '2012-12-12 12:15', ends_at: '2012-12-12 18:30',
      team: create(:team, organization: organization, name: 'Reactor sweeping'),
      plan: create(:plan, organization: organization, name: 'Cleaning')
    )
  end
  let(:notification) do
    create(:upcoming_scheduling_notification,
      employee: employee_mr_burns,
      notifiable: scheduling)
  end
  let(:mail) do
    described_class.upcoming_scheduling(notification)
  end


  context "#upcoming_scheduling" do

    context "mail headers" do
      it "has the clockwork 'no-reply' email address in the senders list" do
        mail.from.should == [ 'no-reply@app.clockwork.io' ]
      end

      it "has mr burns' email address in the recipients list" do
        mail.to.should == [ 'c.burns@npp-springfield.com' ]
      end
    end

    context "when the user has no locale set" do
      it "has a german subject" do
        mail.subject.should == 'Erinnerung: Anstehende Schicht (Springfield Nuclear Power Plant / Sector 7-G / Cleaning)'
      end

      it "has a german body" do
        expect(mail.body).to include('Sie sind für eine Schicht am Mittwoch, 12.12.2012 (12:15-18:30 Reactor sweeping [Rs]) eingeteilt')
      end
    end

    context "when the user has the english locale set" do

      let(:mr_burns) do
        create(:mr_burns, locale: 'en')
      end

      it "has an english subject" do
        mail.subject.should == 'Reminder: Upcoming shift (Springfield Nuclear Power Plant / Sector 7-G / Cleaning)'
      end

      it "has an english body" do
        expect(mail.body).to include('You are scheduled for a shift on Wednesday, 12.12.2012 (12:15-18:30 Reactor sweeping [Rs]).')
      end
    end
  end
end
