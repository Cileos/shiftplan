require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Availability do
  before(:each) do
    @availability = Availability.new
  end

  describe "associations" do
    it "should belong to an employee" do
      @availability.should belong_to(:employee)
    end
  end

  describe "validations" do
    it "should require a start time" do
      @availability.should validate_presence_of(:start)
    end

    it "should require a end time" do
      @availability.should validate_presence_of(:end)
    end

    it "should require a day of week between 0 and 6" do
      @availability.day_of_week = -1
      @availability.should_not be_valid
      @availability.should have_at_least(1).error_on(:day_of_week)

      @availability.day_of_week = 7
      @availability.should_not be_valid
      @availability.should have_at_least(1).error_on(:day_of_week)

      0.upto(6) do |day_of_week|
        @availability.day_of_week = day_of_week
        @availability.valid?
        @availability.should have(:no).errors_on(:day_of_week)
      end
    end
  end

  describe "scopes" do
    describe ".default" do
      it "should have a .default scope" do
        Availability.default.proxy_options[:conditions].should == "day IS NULL AND day_of_week IS NOT NULL"
      end
    end

    describe ".override" do
      it "should have a .override scope" do
        Availability.override.proxy_options[:conditions].should == "day_of_week IS NULL AND day IS NOT NULL"
      end
    end
  end
end
