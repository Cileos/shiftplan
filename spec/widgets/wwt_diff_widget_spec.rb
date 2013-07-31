require 'spec_helper'

describe WwtDiffWidget do
  let(:view) { stub 'View' }
  let(:employee) { stub 'Employee', weekly_working_time: nil }
  let(:records) { [] }
  subject { described_class.new(view, employee, records) }

  it "uses abbr tag to hide data on small displays" do
    short = stub 'short'
    long  = stub 'long'
    subject.stub(:short_label_text).with().and_return(short)
    subject.stub(:long_label_text).with().and_return(long)
    # color
    subject.stub(:label_class).and_return('wwt_class')
    view.should_receive(:abbr_tag).with(short, long, class: "badge wwt_class").and_return('tag')
    subject.to_html.should == 'tag'
  end

  context '#hours' do
    it "sums up records with full hours" do
      records << stub('s1', employee: employee, length_in_hours: 4)
      records << stub('s2', employee: employee, length_in_hours: 8)
      records << stub('s3', employee: employee, length_in_hours: 15)

      subject.hours.should == 4 + 8 + 15
    end

    it "ignores records by other employees" do
      records << stub('s4', employee: stub('other'), length_in_hours: 9000)

      subject.hours.should == 0
    end

    it "sums up records with 15-minute intervals" do
      records << stub('s1', employee: employee, length_in_hours: 4.5)
      records << stub('s2', employee: employee, length_in_hours: 8.75)

      subject.hours.should == 13.25
    end
  end

  describe '#human_hours' do
    let(:formatted) { stub 'formatted hours' }
    it "uses helper" do
      Volksplaner::Formatter.stub(:human_hours).with(4.5).and_return(formatted)
      subject.stub hours: 4.5
      subject.human_hours.should == formatted
    end
  end

  context 'color' do
    let(:label_class) { subject.label_class }

    it "is grey for employee without wwt" do
      employee.stub weekly_working_time: nil
      label_class.should == 'badge-normal'
    end

    it "is yellow for underscheduled employee" do
      employee.stub weekly_working_time: 20
      subject.stub hours: 10
      label_class.should == 'badge-warning'
    end

    it "is green for exactly scheduled employee" do
      employee.stub weekly_working_time: 20
      subject.stub hours: 20
      label_class.should == 'badge-success'
    end

    it "is read for overscheduled employee" do
      employee.stub weekly_working_time: 20
      subject.stub hours: 30
      label_class.should == 'badge-important'
    end
  end

  context 'label' do
    in_locale :de
    let(:long_label) { subject.long_label_text }
    let(:short_label) { subject.short_label_text }

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
      long_label.should == '10 of 20'
    end
  end
end
