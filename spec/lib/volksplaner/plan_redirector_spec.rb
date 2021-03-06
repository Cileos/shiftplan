require 'spec_helper'

describe Volksplaner::PlanRedirector do
  let(:controller) { double('controller').as_null_object }
  let(:plan)   { double 'plan' }
  let(:target) { double 'redirect target' }
  let(:redirector) { described_class.new(controller, plan) }

  def d(date_string)
    Time.zone.parse(date_string)
  end

  it "uses monday of used date" do
    redirector.should_receive(:default_calendar_path).with(2011, 52).and_return(target)
    redirector.week_path( d('2012-01-01') ).should == target
  end

  it "defaults to employees in week" do
    plan.stub organization: (organization = double)
    organization.stub account: (account = double)
    controller.stub(:account_organization_plan_employees_in_week_path).
               with( account, organization, plan, 2063, 19).
               and_return(target)
    redirector.default_calendar_path(2063,19).should == target
  end

  context "redirect without filter" do
    it "redirects to week within plan" do
      redirector.should_receive(:week_within_plan_path).and_return(target)
      controller.should_receive(:redirect_to).with(target)
      redirector.redirect
    end
    context "without period" do
      before :each do
        plan.stub(:has_period?) { false }
      end
      it "redirects to current week" do
        Timecop.freeze
        redirector.stub(:week_path).with(Time.zone.now).and_return(target)
        redirector.week_within_plan_path.should == target
      end
    end
    context "with period" do
      let(:period) { double 'period' }
      before :each do
        plan.stub(:has_period?) { true }
        plan.stub(:period).and_return(period)
      end
      it "goes to first week if today before period" do
        Timecop.travel '2011-12-15'
        period.stub(:starts_after?) { true }
        plan.stub starts_at: d("2012-01-01")
        redirector.should_receive(:week_path).with(plan.starts_at).and_return(target)
        redirector.week_within_plan_path.should == target
      end

      it "goes to last week if today after period" do
        Timecop.travel '2011-02-01'
        period.stub(:starts_after?) { false }
        period.stub(:ends_before?) { true }
        plan.stub ends_at: d("2012-01-28")
        redirector.should_receive(:week_path).with(plan.ends_at).and_return(target)
        redirector.week_within_plan_path.should == target
      end
    end
  end

  context "validate and redirect with filter" do
    let(:filter)     { double 'filter' }
    context "without period" do
      it "does not redirect" do
        plan.stub :has_period? => false
        controller.should_not_receive(:redirect_to)
        redirector.validate_and_redirect(double)
      end
    end
    context "with period" do
      let(:period) { double 'period' }
      before :each do
        plan.stub(:has_period?) { true }
        plan.stub(:period).and_return(period)
      end
      it "redirects to first week if filter before period" do
        plan.stub :has_period? => true, :starts_at => (starts_at = double)
        filter.stub :before_start_of_plan? => true
        filter.stub(:path_to_date).with(starts_at) { target }
        controller.should_receive(:redirect_to).with(target)
        redirector.validate_and_redirect filter
      end
      it "redirects to last week if filter after period" do
        plan.stub :has_period? => true, :ends_at => (ends_at = double)
        filter.stub :before_start_of_plan? => false
        filter.stub :after_end_of_plan? => true

        filter.stub(:path_to_date).with(ends_at) { target }
        controller.should_receive(:redirect_to).with(target)
        redirector.validate_and_redirect filter
      end
    end
  end

end

