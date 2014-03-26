require 'spec_helper'

describe Report do

  let(:report)         { Report.new(report_params) }
  let(:account)        { create(:account) }
  let(:report_params)  { { account: account } }
  let(:organization)   { create(:organization, account: account) }
  let(:plan)           { create(:plan, organization: organization) }

  let(:other_organization)  { create(:organization, account: account) }
  let(:other_plan)          { create(:plan, organization: other_organization) }

  before do
    Timecop.freeze('15.10.2014')
  end

  context "filter by date" do
    let!(:s0) { create(:scheduling, plan: plan, quickie: '8-24',  date: '02.12.2012' ) }
    let!(:s1) { create(:scheduling, plan: plan, quickie: '0-24',  date: '03.12.2012' ) }
    let!(:s2) { create(:scheduling, plan: plan, quickie: '1-2',   date: '03.12.2012' ) }
    let!(:s3) { create(:scheduling, plan: plan, quickie: '14-18', date: '10.12.2012' ) }
    let!(:s4) { create(:scheduling, plan: plan, quickie: '0-8',   date: '11.12.2012' ) }

    let(:report_params) do
      super().merge(from: '03.12.2012', to: '10.12.2012')
    end

    it "includes schedulings in given range" do
      report.records.should == [s3, s2, s1]
    end
  end

  context "filter account or organization wide" do

    let!(:s0) { create(:scheduling, plan: plan, quickie: '8-24',  date: '03.10.2014' ) }
    let!(:s1) { create(:scheduling, plan: other_plan, quickie: '8-24',  date: '02.10.2014' ) }

    context "when no organization given" do

      it "finds schedulings within the account" do
        report.records.should == [s0, s1]
      end
    end

    context "when organization given" do

      let(:report_params) do
        super().merge(organization: organization)
      end

      it "finds schedulings within the organization" do
        report.records.should == [s0]
      end
    end
  end

end
