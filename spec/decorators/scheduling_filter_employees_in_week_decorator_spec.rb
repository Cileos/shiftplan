require 'spec_helper'

describe SchedulingFilterEmployeesInWeekDecorator do

  let(:filter)    { Scheduling.filter }
  let(:decorator) { described_class.new(filter) }

  it "sorts schedulings by start hour" do
    employee = create :employee
    schedulings = [
      create(:scheduling, start_hour: 23),
      create(:scheduling, start_hour: 6),
      create(:scheduling, start_hour: 17)
    ]
    day = mock('day')
    decorator.should_receive(:indexed).with(day, employee).and_return( schedulings )
    decorator.schedulings_for(day, employee).map(&:start_hour).should == [6,17,23]
  end

  context "cell metadata" do
    let(:day) { stub 'Date', iso8601: 'in_iso8601' }

    it "sets employee-id and date" do
      employee = stub 'Employee', id: 23
      decorator.cell_metadata(day,employee).
        should be_hash_matching(:'employee-id' => 23,
                                :date => 'in_iso8601')
    end

    it "sets employee-id to 'missing' without emplyoee" do
      decorator.cell_metadata(day,nil).
        should be_hash_matching(:'employee-id' => 'missing',
                                :date => 'in_iso8601')
    end
  end

  context "hours for employee" do
    let(:employee) { stub 'employee' }
    it "sums up over schedulings of user, rounding after" do
      records = [
        stub(employee: employee, length_in_hours: 5.5),
        stub(employee: employee, length_in_hours: 10.5),
        stub(employee: nil, length_in_hours: 100)
      ]
      decorator.stub records: records
      decorator.hours_for(employee).should == 16
    end
  end

  context "wwt_diff" do
    let(:employee) { stub 'employee' }
    it "sets color by css class" do
      employee.as_null_object
      decorator.stub(:wwt_diff_label_class_for).with(employee).and_return('kunterbunt')

      decorator.wwt_diff_for(employee).should have_tag('abbr.kunterbunt')
    end
    it "sets long and short label" do
      employee.as_null_object
      decorator.stub(:wwt_diff_label_text_for).with(employee).and_return('LONG')
      decorator.stub(:wwt_diff_label_text_for).with(employee, short: true).and_return('SHORT')
      decorator.wwt_diff_for(employee).should have_tag('abbr[title="LONG"] span', text: 'SHORT')
    end

    context 'color' do
      let(:label_class) { decorator.wwt_diff_label_class_for(employee) }

      it "is grey for employee without wwt" do
        employee.stub weekly_working_time: nil
        label_class.should == 'badge-normal'
      end

      it "is yellow for underscheduled employee" do
        employee.stub weekly_working_time: 20
        decorator.stub(:hours_for).with(employee).and_return(10)
        label_class.should == 'badge-warning'
      end

      it "is green for exactly scheduled employee" do
        employee.stub weekly_working_time: 20
        decorator.stub(:hours_for).with(employee).and_return(20)
        label_class.should == 'badge-success'
      end

      it "is read for overscheduled employee" do
        employee.stub weekly_working_time: 20
        decorator.stub(:hours_for).with(employee).and_return(30)
        label_class.should == 'badge-important'
      end
    end

    context 'label' do
      let(:long_label) { decorator.wwt_diff_label_text_for(employee) }
      let(:short_label) { decorator.wwt_diff_label_text_for(employee, short: true) }

      it "shows hours only for employee without wwt" do
        employee.stub weekly_working_time: nil
        decorator.stub(:hours_for).with(employee).and_return(10)
        short_label.should == '10'
        long_label.should == '10'
      end

      it "shows difference for employee with wwt" do
        employee.stub weekly_working_time: 20
        decorator.stub(:hours_for).with(employee).and_return(10)
        short_label.should == '10 / 20'
        long_label.should == '10 of 20'
      end
    end
  end

end

