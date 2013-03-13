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
    it "offers all days of the week" do
      helper.cwdays_for_select(scheduling).should have(7).items
    end
  end
end
