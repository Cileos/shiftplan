require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DefaultAvailability do
  before(:each) do
    @default_availability = DefaultAvailability.new
  end

  describe "associations" do
    it "should belong to an employee" do
      @default_availability.should belong_to(:employee)
    end
  end

  describe "validations" do
    it "should require a start time" do
      @default_availability.should validate_presence_of(:start)
    end

    it "should require a end time" do
      @default_availability.should validate_presence_of(:end)
    end

    it "should require a day of week between 0 and 6" do
      @default_availability.should validate_presence_of(:day_of_week)

      @default_availability.day_of_week = -1
      @default_availability.should_not be_valid
      @default_availability.should have_at_least(1).error_on(:day_of_week)

      @default_availability.day_of_week = 7
      @default_availability.should_not be_valid
      @default_availability.should have_at_least(1).error_on(:day_of_week)

      0.upto(6) do |day_of_week|
        @default_availability.day_of_week = day_of_week
        @default_availability.valid?
        @default_availability.should have(:no).errors_on(:day_of_week)
      end
    end
  end
end
