require 'spec_helper'


describe Plan::Period do
  let(:from) { Time.zone.parse('2012-12-27') }
  let(:to)   { Time.zone.parse('2012-12-31') }
  context "with start and end" do
    let(:period) { described_class.new(from, to)}
    it "excludes dates before" do
      period.should_not include( from - 3.days )
    end
    it "excludes dates after" do
      period.should_not include( to + 1.day )
    end
    it "includes date within" do
      period.should include( from + 2.day )
    end
    it "includes its own start" do
      period.should include(from)
    end
    it "includes its own end" do
      period.should include(to)
    end
    it "includes its own start as date" do
      period.should be_include_date(from)
    end
    it "includes its own end as date" do
      period.should be_include_date(to)
    end
  end

  context "with start only" do
    let(:period) { described_class.new(from, nil)}
    it "starts after earlier dates" do
      period.should be_starts_after( from - 1.day )
    end

    it "does not start after later dates" do
      period.should_not be_starts_after( from + 1.day )
    end

    it "does not end after anything (cannot tell)" do
      period.should_not be_ends_before( stub )
    end

    it "excludes earlier dates" do
      period.should be_exclude( from - 1.day)
    end

    it "includes later dates" do
      period.should include( from + 1.day )
    end
  end

  context "with end only" do
    let(:period) { described_class.new(nil, to)}
    it "ends before later dates" do
      period.should be_ends_before( to + 1.day)
    end

    it "does not end before earlier dates" do
      period.should_not be_ends_before( to - 1.day)
    end

    it "does not start after anything (cannot tell)" do
      period.should_not be_starts_after( stub )
    end

    it "excludes later dates" do
      period.should be_exclude( to + 1.day)
    end

    it "includes earlier dates" do
      period.should include( to - 1.day )
    end
  end

  context "without any restriction" do
    let(:period) { described_class.new(nil, nil) }
    it "includes any date" do
      date = stub 'any date'
      period.should include(date)
    end
  end

end
