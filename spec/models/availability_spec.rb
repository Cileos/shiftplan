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
      before(:each) do
        @default_availability = Availability.create!(:employee_id => 1, :day_of_week => 0,    :start => '09:00', :end => '17:00')
        @override             = Availability.create!(:employee_id => 1, :day => '2009-11-22', :start => '09:00', :end => '17:00')
      end

      it "should include default availabilites" do
        Availability.default.should include(@default_availability)
      end

      it "should not include overrides" do
        Availability.default.should_not include(@override)
      end
    end

    describe ".override" do
      before(:each) do
        @default_availability = Availability.create!(:employee_id => 1, :day_of_week => 0,    :start => '09:00', :end => '17:00')
        @override             = Availability.create!(:employee_id => 1, :day => '2009-11-22', :start => '09:00', :end => '17:00')
      end

      it "should include overrides" do
        Availability.override.should include(@override)
      end

      it "should not include default availabilites" do
        Availability.override.should_not include(@default_availability)
      end
    end
  end
end
