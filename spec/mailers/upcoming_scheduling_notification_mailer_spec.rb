# encoding: utf-8
describe UpcomingSchedulingNotificationMailer do

  let(:mr_burns) do
    create(:mr_burns)
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
      team: create(:team, organization: organization, name: 'Reaktor fegen'),
      plan: create(:plan, organization: organization)
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

    context "mail subject" do
      it "has a descriptive subject" do
        mail.subject.should == 'Erinnerung: Anstehende Schicht'
      end
    end

    context "mail body" do
      it "includes infos about the upcoming scheduling" do
        expect(mail.body).to include('Sie sind für eine eine Schicht am Mittwoch, den 12.12.2012 (12:15-18:30 Reaktor fegen [Rf]) eingeteilt')
      end
    end

  end
end
