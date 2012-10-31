require 'spec_helper'

describe SchedulingFilterDecorator, 'mode' do
  let(:filter) { SchedulingFilter.new }
  it "selects the decorator by given mode" do
    decorator = mock('Decorator')
    SchedulingFilterEmployeesInWeekDecorator.should_receive(:new).with(filter, {foo: 23}).and_return(decorator)
    SchedulingFilterHoursInWeekDecorator.should_not_receive(:new)
    SchedulingFilterDecorator.decorate(filter, {foo: 23, mode: 'employees_in_week'}).should == decorator
  end

  it "should deny any unknown modes" do
    expect { SchedulingFilterDecorator.decorate(filter, mode: 'with_blackjack_and_hookers') }.to raise_error
  end

  it "plan period for plan with start and end date" do
    plan = build :plan, starts_at: Time.zone.parse('2012-12-12'), ends_at: Time.zone.parse('2012-12-24')
    filter = SchedulingFilter.new plan: plan
    decorator = SchedulingFilterDecorator.new(filter)
    decorator.plan_period.should == "Beginnt: 12.12.2012 Endet: 24.12.2012"
  end

  it "plan period for plan with only start date" do
    plan = build :plan, starts_at: Time.zone.parse('2012-12-12')
    filter = SchedulingFilter.new plan: plan
    decorator = SchedulingFilterDecorator.new(filter)
    decorator.plan_period.should == "Beginnt: 12.12.2012"
  end

  it "plan period for plan with only end date" do
    plan = build :plan, ends_at: Time.zone.parse('2012-12-24')
    filter = SchedulingFilter.new plan: plan
    decorator = SchedulingFilterDecorator.new(filter)
    decorator.plan_period.should == "Endet: 24.12.2012"
  end

  describe 'render_cell_for_day' do
    let(:decorator) { SchedulingFilterDecorator.new(filter) }
    let(:view)    { mock('View').tap    { |v| decorator.stub(:h).and_return(v) } }
    let(:content) { mock('content').tap { |c| decorator.stub(:cell_content).and_return(c) } }
    before :each do
      decorator.stub(:outside_plan_period?).and_return(false)
      decorator.stub(:cell_metadata).and_return('none')
    end

    describe "for one dimension" do
      it "accepts an extra class" do
        view.should_receive(:content_tag).with(:td, content, class: "day", data: 'none')
        decorator.render_cell_for_day(23, class: "day")
      end

      it "joins an extra class with outside plan period" do
        decorator.stub(:outside_plan_period?).and_return(true)
        view.should_receive(:content_tag).with(:td, content, class: "outside_plan_period day", data: 'none')
        decorator.render_cell_for_day(23, class: "day")
      end
    end

    describe "for two dimensions" do
      it "accepts an extra class" do
        view.should_receive(:content_tag).with(:td, content, class: "day", data: 'none')
        decorator.render_cell_for_day(23, 42, class: "day")
      end

      it "joins an extra class with outside plan period" do
        decorator.stub(:outside_plan_period?).and_return(true)
        view.should_receive(:content_tag).with(:td, content, class: "outside_plan_period day", data: 'none')
        decorator.render_cell_for_day(23, 42, class: "day")
      end
    end

  end

end
