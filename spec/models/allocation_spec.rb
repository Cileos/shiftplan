require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Allocation do
  before(:each) do
    @allocation = Allocation.new
  end

  describe "validations" do
    before(:each) do
      @allocation.attributes = {
        :workplace_id => 1,
        :employee_id => 1,
        :start => Time.now,
        :end => 8.hours.from_now
      }
    end

    it "should regard a valid object as valid" do
      @allocation.should be_valid
    end

    it "should require a start time" do
      @allocation.should validate_presence_of(:start)
    end

    it "should require an end time" do
      @allocation.should validate_presence_of(:end)
    end
    
    it "should have a start time before its end time" do
      @allocation.end = 2.hours.ago
      @allocation.should_not be_valid
    end

    it "should require an employee" do
      @allocation.should validate_presence_of(:employee_id)
    end

    it "should require a workplace" do
      @allocation.should validate_presence_of(:workplace_id)
    end
  end

  describe "scopes" do
    describe ".for_week" do
      proxy_options = Allocation.for_week(2009, 50).proxy_options
      start_date, end_date = Time.local(2009, 12, 7, 0, 0), Time.local(2009, 12, 13, 23, 59, 59)
      proxy_options[:conditions].should == ["(start BETWEEN ? AND ?) OR (end BETWEEN ? AND ?)", start_date, end_date, start_date, end_date]
      proxy_options[:order].should == "start ASC, end ASC"
    end

    describe ".for_year" do
      proxy_options = Allocation.for_year(2009).proxy_options
      start_date, end_date = Time.local(2009, 1, 1, 0, 0), Time.local(2009, 12, 31, 23, 59, 59)
      proxy_options[:conditions].should == ["(start BETWEEN ? AND ?) OR (end BETWEEN ? AND ?)", start_date, end_date, start_date, end_date]
      proxy_options[:order].should == "start ASC, end ASC"
    end

    describe ".for_month" do
      proxy_options = Allocation.for_month(2009, 12).proxy_options
      start_date, end_date = Time.local(2009, 12, 1, 0, 0), Time.local(2009, 12, 31, 23, 59, 59)
      proxy_options[:conditions].should == ["(start BETWEEN ? AND ?) OR (end BETWEEN ? AND ?)", start_date, end_date, start_date, end_date]
      proxy_options[:order].should == "start ASC, end ASC"
    end

    describe ".for_day" do
      proxy_options = Allocation.for_day(2009, 12, 7).proxy_options
      start_date, end_date = Time.local(2009, 12, 7, 0, 0), Time.local(2009, 12, 7, 23, 59, 59)
      proxy_options[:conditions].should == ["(start BETWEEN ? AND ?) OR (end BETWEEN ? AND ?)", start_date, end_date, start_date, end_date]
      proxy_options[:order].should == "start ASC, end ASC"
    end
  end
end
