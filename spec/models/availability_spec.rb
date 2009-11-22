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
        @sunday_default  = Availability.create!(:employee_id => 1, :day_of_week => 0,    :start => '09:00', :end => '17:00')
        @sunday_override = Availability.create!(:employee_id => 1, :day => '2009-11-22', :start => '08:00', :end => '16:00')
      end

      it "should include default availabilities" do
        Availability.default.should include(@sunday_default)
      end

      it "should not include overrides" do
        Availability.default.should_not include(@sunday_override)
      end
    end

    describe ".override" do
      before(:each) do
        @sunday_default  = Availability.create!(:employee_id => 1, :day_of_week => 0,    :start => '09:00', :end => '17:00')
        @sunday_override = Availability.create!(:employee_id => 1, :day => '2009-11-22', :start => '08:00', :end => '16:00')
      end

      it "should include overrides" do
        Availability.override.should include(@sunday_override)
      end

      it "should not include default availabilities" do
        Availability.override.should_not include(@sunday_default)
      end
    end
  end

  describe "class methods" do
    describe ".for" do
      before(:each) do
        @sunday_default    = Availability.create!(:employee_id => 1, :day_of_week => 0,    :start => '09:00', :end => '17:00')
        @monday_default    = Availability.create!(:employee_id => 1, :day_of_week => 1,    :start => '06:00', :end => '14:00')
        @monday_default_2  = Availability.create!(:employee_id => 1, :day_of_week => 1,    :start => '16:00', :end => '23:00')
        @sunday_override   = Availability.create!(:employee_id => 1, :day => '2009-11-22', :start => '06:00', :end => '14:00')
        @sunday_override_2 = Availability.create!(:employee_id => 1, :day => '2009-11-22', :start => '16:00', :end => '23:00')
      end

      describe "with only one parameter (= day)" do
        it "should include the overrides if at least one override is defined for the given day" do
          availabilities = Availability.for(Date.civil(2009, 11, 22))
          availabilities.should include(@sunday_override)
          availabilities.should include(@sunday_override_2)
        end

        it "should not include the defaults if at least one override is defined for the given day" do
          Availability.for(Date.civil(2009, 11, 22)).should_not include(@sunday_default)
        end

        it "should include the defaults if no override is defined for the given day" do
          availabilities = Availability.for(Date.civil(2009, 11, 23))
          availabilities.should include(@monday_default)
          availabilities.should include(@monday_default_2)
        end

        it "should be empty if no overrides and no defaults are defined for the given day" do
          Availability.for(Date.civil(2009, 11, 24)).should be_empty
        end
      end

      describe "with two parameters (= start and end day)" do
        it "should include the overrides for the given days and fall back to defaults if necessary" do
          start_date = Date.civil(2009, 11, 22)
          end_date   = Date.civil(2009, 11, 23)

          availabilities = Availability.for(start_date, end_date)
          availabilities[start_date].should include(@sunday_override)
          availabilities[start_date].should include(@sunday_override_2)
          availabilities[end_date].should   include(@monday_default)
          availabilities[end_date].should   include(@monday_default_2)
        end

        it "should not include the defaults for the given days if overrides are defined" do
          start_date = Date.civil(2009, 11, 22)
          end_date   = Date.civil(2009, 11, 23)

          availabilities = Availability.for(start_date, end_date)
          availabilities[start_date].should_not include(@sunday_default)
        end

        it "should be empty if no overrides and no defaults are defined for the given days" do
          start_date = Date.civil(2009, 11, 24)
          end_date   = Date.civil(2009, 11, 26)

          availabilities = Availability.for(start_date, end_date)
          (start_date..end_date).each { |day| availabilities[day].should be_empty }
        end
      end
    end
  end
end
