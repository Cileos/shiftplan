# encoding: utf-8
require 'spec_helper'

describe EmployeeWwtDiffWidget do
  let(:view) { double 'View' }
  let(:employee) { double 'Employee', weekly_working_time: nil }
  let(:filter) { double 'SchedulingFilter', h: view }
  let(:records) { [] }
  subject { described_class.new(filter, employee, records) }

  context '#hours' do
    it "sums up records with full hours" do
      records << double('s1', employee: employee, length_in_hours: 4 , all_day?: false)
      records << double('s2', employee: employee, length_in_hours: 8 , all_day?: false)
      records << double('s3', employee: employee, length_in_hours: 15, all_day?: false)

      subject.hours.should == 4 + 8 + 15
    end

    it "sums up records with 15-minute intervals" do
      records << double('s1', employee: employee, length_in_hours: 4.5 , all_day?: false)
      records << double('s2', employee: employee, length_in_hours: 8.75, all_day?: false)

      subject.hours.should == 13.25
    end

    it "ignores records by other employees" do
      records << double('s4', employee: stub('other'), length_in_hours: 9000)

      subject.hours.should == 0
    end

    it "respects all day schedulings" do # they return 0 or their #actual_length_in_hours
      records << double('s1', employee: employee, length_in_hours: 5.5 , all_day?: true)

      subject.hours.should == 5.5
    end

    it "knows how to deal with overnightables on weekends (may count double)"
  end

  context 'additional hours' do
    let(:year) { 2012 }
    let(:week) { 52 }
    def sch(attrs={})
      create :manual_scheduling, attrs.reverse_merge(year: year, week: week, cwday: 1)
    end
    let(:employee) { create :employee }
    let(:other_employee) { create :employee }
    let(:plan) { create :plan }
    let(:other_plan) { create :plan }
    let(:filter) { SchedulingFilter.new plan: plan, week: week, cwyear: year }

    subject { described_class.new(filter, employee, filter.unsorted_records) }

    it 'includes hours from plans in the same account' do
      sch plan: other_plan, employee: employee, quickie: '2-4'
      sch plan: other_plan, employee: employee, quickie: '4-8'

      subject.additional_hours.should == 6
    end


    it 'excludes hours from plan in foreign accounts' do
      sch plan: other_plan, employee: other_employee, quickie: '2-5'
      subject.additional_hours.should == 0
    end

    it 'excludes hours from current plan' do
      sch plan: plan, employee: employee, quickie: '2-5'
      subject.additional_hours.should == 0
    end

    it 'excludes hours from other employees' do
      sch plan: plan, employee: other_employee, quickie: '2-5'
      subject.additional_hours.should == 0
    end

    it 'excludes hours from all day schedulings' do
      sch plan: other_plan, employee: employee, quickie: '2-4', all_day: true
      subject.additional_hours.should == 0
    end
  end

  context 'label' do
    in_locale :de
    let(:long_label) { subject.long_label_text }
    let(:short_label) { subject.short_label_text }

    before :each do
      subject.stub additional_hours: 0
    end

    it "shows hours only for employee without wwt" do
      employee.stub weekly_working_time: nil
      subject.stub hours: 10
      short_label.should == '10'
      long_label.should == '10'
    end

    it "shows difference for employee with wwt" do
      employee.stub weekly_working_time: 20
      subject.stub hours: 10
      short_label.should == '10 / 20'
      long_label.should == '10 von 20'
    end

    it "shows hours in other plans" do
      employee.stub weekly_working_time: 20
      subject.stub hours: 10
      subject.stub additional_hours: 6
      short_label.should == '10 (+6) / 20'
      long_label.should == '10 (6 in anderen Plänen) von 20'
    end
  end
end
