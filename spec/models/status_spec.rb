require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Status do
  before(:each) do
    @status = Status.make(:day => Date.today)
  end

  describe "associations" do
    it "should belong to an employee" do
      @status.should belong_to(:employee)
    end
  end

  describe "validations" do
    it "should require a start time" do
      @status.should validate_presence_of(:start)
    end

    it "should require a end time" do
      @status.should validate_presence_of(:end)
    end

    it "should require a day of week between 0 and 6" do
      @status.day = nil

      @status.day_of_week = -1
      @status.should_not be_valid
      @status.should have_at_least(1).error_on(:day_of_week)

      @status.day_of_week = 7
      @status.should_not be_valid
      @status.should have_at_least(1).error_on(:day_of_week)

      0.upto(6) do |day_of_week|
        @status.day_of_week = day_of_week
        @status.valid?
        @status.should have(:no).errors_on(:day_of_week)
      end
    end

    it "should require either day or day of week to be set" do
      @status.day_of_week = nil
      @status.day         = nil
      @status.should have_at_least(1).error_on(:base)

      @status.day_of_week = 0
      @status.day         = nil
      @status.should have(:no).errors_on(:base)

      @status.day_of_week = nil
      @status.day         = Date.today
      @status.should have(:no).errors_on(:base)
    end

    it "should validate that status is a valid status" do
      Status::VALID_STATUSES.should be_kind_of(Array)

      Status::VALID_STATUSES.each do |status|
        @status.status = status
        @status.valid?
        @status.should have(:no).errors_on(:status)
      end

      %w(foo bar bam baz).each do |status|
        @status.status = status
        @status.valid?
        @status.should have_at_least(1).error_on(:status)
      end
    end
  end

  describe "scopes" do
    describe ".default" do
      before(:each) do
        @sunday_default  = Status.make(:day_of_week => 0,    :start => '09:00', :end => '17:00')
        @sunday_override = Status.make(:day => '2009-11-22', :start => '08:00', :end => '16:00')
      end

      it "should include default statuses" do
        Status.default.should include(@sunday_default)
      end

      it "should not include overrides" do
        Status.default.should_not include(@sunday_override)
      end
    end

    describe ".override" do
      before(:each) do
        @sunday_default  = Status.make(:day_of_week => 0,    :start => '09:00', :end => '17:00')
        @sunday_override = Status.make(:day => '2009-11-22', :start => '08:00', :end => '16:00')
      end

      it "should include overrides" do
        Status.override.should include(@sunday_override)
      end

      it "should not include default statuses" do
        Status.override.should_not include(@sunday_default)
      end
    end
  end

  describe "class methods" do
    describe ".for" do
      before(:each) do
        @sunday_default    = Status.make(:day_of_week => 0,    :start => '09:00', :end => '17:00')
        @monday_default    = Status.make(:day_of_week => 1,    :start => '06:00', :end => '14:00')
        @monday_default_2  = Status.make(:day_of_week => 1,    :start => '16:00', :end => '23:00')
        @sunday_override   = Status.make(:day => '2009-11-22', :start => '06:00', :end => '14:00')
        @sunday_override_2 = Status.make(:day => '2009-11-22', :start => '16:00', :end => '23:00')
      end

      describe "with only one parameter (= day)" do
        it "should include the overrides if at least one override is defined for the given day" do
          statuses = Status.for(Date.civil(2009, 11, 22))
          statuses.should include(@sunday_override)
          statuses.should include(@sunday_override_2)
        end

        it "should not include the defaults if at least one override is defined for the given day" do
          Status.for(Date.civil(2009, 11, 22)).should_not include(@sunday_default)
        end

        it "should include the defaults if no override is defined for the given day" do
          statuses = Status.for(Date.civil(2009, 11, 23))
          statuses.should include(@monday_default)
          statuses.should include(@monday_default_2)
        end

        it "should be empty if no overrides and no defaults are defined for the given day" do
          Status.for(Date.civil(2009, 11, 24)).should be_empty
        end
      end

      describe "with two parameters (= start and end day)" do
        it "should include the overrides for the given days and fall back to defaults if necessary" do
          start_date = Date.civil(2009, 11, 22)
          end_date   = Date.civil(2009, 11, 23)

          statuses = Status.for(start_date, end_date)
          statuses[start_date].should include(@sunday_override)
          statuses[start_date].should include(@sunday_override_2)
          statuses[end_date].should   include(@monday_default)
          statuses[end_date].should   include(@monday_default_2)
        end

        it "should not include the defaults for the given days if overrides are defined" do
          start_date = Date.civil(2009, 11, 22)
          end_date   = Date.civil(2009, 11, 23)

          statuses = Status.for(start_date, end_date)
          statuses[start_date].should_not include(@sunday_default)
        end

        it "should be empty if no overrides and no defaults are defined for the given days" do
          start_date = Date.civil(2009, 11, 24)
          end_date   = Date.civil(2009, 11, 26)

          statuses = Status.for(start_date, end_date)
          (start_date..end_date).each { |day| statuses[day].should be_empty }
        end
      end
    end
  end

  describe "instance methods" do
    Status::VALID_STATUSES.each do |status|
      describe "##{status.underscore}?" do
        it "should return true if status is set to '#{status}'" do
          @status.status = status
          @status.send(:"#{status.underscore}?").should be_true
        end

        it "should return true if status is not set to '#{status}'" do
          @status.status = "foo-#{status}-bar"
          @status.send(:"#{status.underscore}?").should be_false
        end
      end
    end
  end
end
