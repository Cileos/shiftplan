# encoding: utf-8
require 'spec_helper'

describe WwtDiffWidget do
  let(:view) { stub 'View' }
  let(:row_record) { stub 'Record in Row', weekly_working_time: nil }
  let(:filter) { stub 'SchedulingFilter', h: view }
  let(:records) { [] }
  subject { described_class.new(filter, row_record, records) }

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

  describe '#human' do
    let(:formatted) { stub 'formatted hours' }
    it "uses helper" do
      Volksplaner::Formatter.stub(:human_hours).with(4.5).and_return(formatted)
      subject.human(4.5).should == formatted
    end
  end

  context 'color' do
    let(:label_class) { subject.label_class }
    before :each do
      subject.stub wwt?: true
    end

    it "is grey for record without wwt" do
      subject.stub wwt?: false
      label_class.should == 'badge-normal'
    end

    it "is yellow for underscheduled record" do
      subject.stub wwt: 20
      subject.stub all_hours: 10
      label_class.should == 'badge-warning'
    end

    it "is green for exactly scheduled record" do
      subject.stub wwt: 20
      subject.stub all_hours: 20
      label_class.should == 'badge-success'
    end

    it "is read for overscheduled record" do
      subject.stub wwt: 20
      subject.stub all_hours: 30
      label_class.should == 'badge-important'
    end
  end

  context 'label' do
    in_locale :de
    let(:long_label) { subject.long_label_text }
    let(:short_label) { subject.short_label_text }

    before :each do
      subject.stub additional_hours: 0
    end

    it "shows only hours for record without wwt" do
      subject.stub hours: 10
      short_label.should == '10'
      long_label.should == '10'
    end

    it "shows hours in other plans" do
      subject.stub hours: 10
      subject.stub additional_hours: 6
      short_label.should == '10 (+6)'
      long_label.should == '10 (6 in anderen Plänen)'
    end
  end

end
