# encoding: utf-8
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

  context "when date range set" do
    let(:report_params) do
      super().merge(from: '03.12.2012', to: '10.12.2012')
    end

    it 'includes lasting all first day' do
      s = create(:scheduling, plan: plan, quickie: '0-24',      date: '03.12.2012' )
      report.records.should include(s)
    end

    it 'includes beginning one hour after range start' do
      s = create(:scheduling, plan: plan, quickie: '1-2',      date: '03.12.2012' )
      report.records.should include(s)
    end

    it 'includes ending precisely' do
      s = create(:scheduling, plan: plan, quickie: '23:45-24', date: '10.12.2012' )
      report.records.should include(s)
    end

    it 'includes schedulings dangling out of the range at the end' do
      dangle = create(:scheduling, plan: plan, quickie: '22-6', date: '10.12.2012')
      report.records.should include(dangle)
    end

    it 'skips ending before range' do
      s = create(:scheduling, plan: plan, quickie: '8-24',     date: '02.12.2012' )
      report.records.should_not include(s)
    end

    it 'skips starting after range' do
      s = create(:scheduling, plan: plan, quickie: '0-8',      date: '11.12.2012' )
      report.records.should_not include(s)
    end

    it 'skips schedulings dangling into range at the beginning' do
      dangle = create(:scheduling, plan: plan, quickie: '22-6', date: '02.12.2012')
      report.records.should_not include(dangle)
    end
  end

  context "when no date range set" do
    let!(:s0) { create(:scheduling, plan: plan, quickie: '8-24',     date: '30.09.2014' ) }
    let!(:s1) { create(:scheduling, plan: plan, quickie: '0-1',      date: '01.10.2014' ) }
    let!(:s2) { create(:scheduling, plan: plan, quickie: '1-2',      date: '10.10.2014' ) }
    let!(:s3) { create(:scheduling, plan: plan, quickie: '23:45-24', date: '31.10.2014' ) }
    let!(:s4) { create(:scheduling, plan: plan, quickie: '0-8',      date: '01.11.2014' ) }

    it "finds schedulings in the current month" do
      report.records.should match_array [s3, s2, s1]
    end
  end

  it "does not find next days of overnightables" do
    s0 = create(:scheduling, plan: plan, quickie: '22-6', date: '10.10.2014' )

    report.records.should match_array [s0]
  end

  context "filter account or organization wide" do
    let(:organization_plan_b)  { create(:organization, account: account) }
    let(:plan_b)               { create(:plan, organization: organization_plan_b) }

    let!(:s0) { create(:scheduling, plan: plan, quickie: '8-24',  date: '03.10.2014' ) }
    let!(:s1) { create(:scheduling, plan: other_plan, quickie: '8-24',  date: '02.10.2014' ) }
    let!(:s2) { create(:scheduling, plan: plan_b, quickie: '8-24',  date: '02.10.2014' ) }

    context "when no organization given" do

      it "finds schedulings within the account" do
        report.records.should match_array [s0, s1, s2]
      end
    end

    context "when organizations are selected" do
      let(:report_params) do
        super().merge(organization_ids: ['', organization.id, other_organization.id])
      end

      it "finds schedulings for the selected organizations" do
        report.records.should match_array [s0, s1]
      end
    end
  end

  context "filter by employee" do
    let!(:s0) { create(:scheduling, employee: homer, plan: plan, quickie: '8-24',  date: '01.10.2014' ) }
    let!(:s1) { create(:scheduling, employee: bart,  plan: plan, quickie: '8-24',  date: '02.10.2014' ) }
    let!(:s2) { create(:scheduling, employee: maggie,  plan: plan, quickie: '8-24',  date: '03.10.2014' ) }

    let(:homer)  { create(:employee, name: 'Homer') }
    let(:bart)   { create(:employee, name: 'Bart') }
    let(:maggie) { create(:employee, name: 'Maggie') }

    context "when employees are selected" do

      let(:report_params) do
        super().merge(employee_ids: ['', homer.id, bart.id])
      end

      it "finds schedulings of the employees" do
        report.records.should match_array [s0, s1]
      end
    end

    context "when no employee is selected (only blank option)" do

      let(:report_params) do
        super().merge(employee_ids: [''])
      end

      it "finds all schedulings" do
        report.records.should match_array [s0, s1, s2]
      end
    end
  end

  context "filter by team" do
    let!(:s0) { create(:scheduling, team: t0, plan: plan, quickie: '8-24',  date: '01.10.2014' ) }
    let!(:s1) { create(:scheduling, team: t1, plan: plan, quickie: '8-24',  date: '02.10.2014' ) }
    let!(:s2) { create(:scheduling, team: t2, plan: plan, quickie: '8-24',  date: '03.10.2014' ) }

    let(:t0) { create(:team, name: 'Tellerwäscher') }
    let(:t1) { create(:team, name: 'Fensterputzer') }
    let(:t2) { create(:team, name: 'Schornsteinfeger') }

    context "when teams are selected" do

      let(:report_params) do
        super().merge(team_ids: ['', t0.id, t1.id])
      end

      it "finds schedulings of the teams" do
        report.records.should match_array [s0, s1]
      end
    end

    context "when no team is selected (only blank option)" do

      let(:report_params) do
        super().merge(team_ids: [''])
      end

      it "finds all schedulings" do
        report.records.should match_array [s0, s1, s2]
      end
    end
  end

  context "filter by plan" do
    let!(:s0) { create(:scheduling, plan: p0, quickie: '8-24',  date: '01.10.2014' ) }
    let!(:s1) { create(:scheduling, plan: p1, quickie: '8-24',  date: '02.10.2014' ) }
    let!(:s2) { create(:scheduling, plan: p2, quickie: '8-24',  date: '03.10.2014' ) }

    let(:p0) { create(:plan, name: 'Reaktor A', organization: organization) }
    let(:p1) { create(:plan, name: 'Reaktor B', organization: organization) }
    let(:p2) { create(:plan, name: 'Reaktor C', organization: organization) }

    context "when plans are selected" do

      let(:report_params) do
        super().merge(plan_ids: ['', p0.id, p1.id])
      end

      it "finds schedulings of the plans" do
        report.records.should match_array [s0, s1]
      end
    end

    context "when no plan is selected (only blank option)" do

      let(:report_params) do
        super().merge(plan_ids: [''])
      end

      it "finds all schedulings" do
        report.records.should match_array [s0, s1, s2]
      end
    end
  end

  context "when limit given" do

    let!(:s0) { create(:scheduling, plan: plan, quickie: '8-24',  date: '01.10.2014' ) }
    let!(:s1) { create(:scheduling, plan: plan, quickie: '8-24',  date: '02.10.2014' ) }

    let(:report_params) do
      super().merge(limit: 1)
    end

    it "finds the limited number of schedulings" do
      report.records.should match_array [s1]
    end

    context "when limit is 'all'" do

      let(:report_params) do
        super().merge(limit: 'all')
      end

      it "finds all schedulings" do
        report.records.should match_array [s1, s0]
      end
    end
  end

  context "totals" do

    let!(:s0) { create(:scheduling, plan: plan, quickie: '22-6', date: '03.10.2014' )  }
    let!(:s1) { create(:scheduling, plan: plan, quickie: '1-2', date: '02.10.2014' ) }
    let!(:s2) { create(:scheduling, plan: plan, quickie: '1-4', date: '01.10.2014' ) }

    let(:report_params) do
      super().merge(limit: 2)
    end

    describe "#total_duration" do

      it "sums up time of all schedulings regardless of limit" do
        report.total_duration.should == 12.0
      end

      it "sums up time excluding all day schedulings" do
        s3 = create(:scheduling, plan: plan, quickie: '1-4', date: '01.10.2014', all_day: true)
        report.total_duration.should == 12.0
      end
    end

    describe "#total_number_of_records" do

      it "sums up number of all schedulings regardless of limit" do
        report.total_number_of_records.should == 3
      end
    end
  end
end
