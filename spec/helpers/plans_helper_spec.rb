require 'spec_helper'

describe PlansHelper do
  context "employees_for_select for a scheduling" do
    let(:scheduling) { create :scheduling }
    let(:employee) { create :employee }
    it "includes employee of its organization" do
      create :membership, employee: employee, organization: scheduling.organization

      helper.employees_for_select(scheduling).should include(employee)
    end
    it "excludes employee of other organizations" do
      create :membership, employee: employee, organization: create(:organization)

      helper.employees_for_select(scheduling).should_not include(employee)
    end
  end

  context "cwdays_for_select" do
    let(:scheduling) { stub('scheduling', date: Time.zone.now.to_date).as_null_object }

    context "without period" do
      it "offers all days of the week" do
        helper.cwdays_for_select(scheduling).should have(7).items
      end
    end

    context "with period from sunday to tuesday" do
      let(:period) { Plan::Period.new(Time.zone.parse('2012-01-01'), Time.zone.parse('2012-01-03')) }
      before :each do
        scheduling.stub(:plan).and_return(stub('plan', period: period))
      end
      context "for first week" do
        let(:scheduling) { stub date: period.starts_at.to_date }
        it "offers only sunday" do
          helper.cwdays_for_select(scheduling).map(&:last).should == ['01.01.2012']
        end
      end
      context "for second week" do
        let(:scheduling) { stub date: period.ends_at.to_date }
        it "offers only monday and tuesday" do
          helper.cwdays_for_select(scheduling).map(&:last).should == ['02.01.2012', '03.01.2012']
        end
      end
    end
  end
end
