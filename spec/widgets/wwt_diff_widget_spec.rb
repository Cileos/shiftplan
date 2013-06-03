require 'spec_helper'

describe WwtDiffWidget do
  let(:view) { stub 'View' }
  let(:employee) { stub 'Employee', weekly_working_time: nil }
  let(:records) { [] }
  subject { described_class.new(view, employee, records) }

  it "uses abbr tag to hide data on small displays" do
    short = stub 'short'
    long  = stub 'long'
    subject.stub(:wwt_diff_label_text_for).with(employee, short: true).and_return(short)
    subject.stub(:wwt_diff_label_text_for).with(employee).and_return(long)
    subject.stub(:wwt_diff_label_class_for).with(employee).and_return('wwt_class')
    view.should_receive(:abbr_tag).with(short, long, class: "badge wwt_class").and_return('tag')
    subject.to_html.should == 'tag'
  end
end
