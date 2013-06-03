require 'spec_helper'

describe WwtDiffWidget do
  let(:view) { stub 'View' }
  let(:employee) { stub 'Employee', weekly_working_time: nil }
  let(:records) { [] }
  subject { described_class.new(view, employee, records) }

  it "uses abbr tag to hide data on small displays" do
    short = stub 'short'
    long  = stub 'long'
    subject.stub(:label_text).with(short: true).and_return(short)
    subject.stub(:label_text).with().and_return(long)
    subject.stub(:label_class).and_return('wwt_class')
    view.should_receive(:abbr_tag).with(short, long, class: "badge wwt_class").and_return('tag')
    subject.to_html.should == 'tag'
  end

  context '#hours' do
    it "sums up full hours" do
      records << stub('s1', employee: employee, length_in_hours: 4)
      records << stub('s2', employee: employee, length_in_hours: 8)
      records << stub('s3', employee: employee, length_in_hours: 15)

      subject.hours.should == 4 + 8 + 15
    end
  end
end
