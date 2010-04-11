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
      @status.should validate_presence_of(:start_time)
    end

    it "should require a end time" do
      @status.should validate_presence_of(:end_time)
    end

    it "should require a day of week between 0 and 6" do
      @status.day = nil

      @status.day_of_week = -1
      @status.should_not be_valid
      # @status.should have_at_least(1).error_on(:day_of_week)
      @status.errors[:day_of_week].size.should be >= 1

      @status.day_of_week = 7
      @status.should_not be_valid
      # @status.should have_at_least(1).error_on(:day_of_week)
      @status.errors[:day_of_week].size.should be >= 1

      0.upto(6) do |day_of_week|
        @status.day_of_week = day_of_week
        @status.valid?
        # @status.should have(:no).errors_on(:day_of_week)
        @status.errors[:day_of_week].should be_empty
      end
    end

    it "should require either day or day of week to be set" do
      @status.day_of_week = nil
      @status.day         = nil
      # @status.should have_at_least(1).error_on(:base)
      @status.valid?
      @status.errors[:base].size.should be >= 1

      @status.day_of_week = 0
      @status.day         = nil
      @status.valid?
      # @status.should have(:no).errors_on(:base)
      @status.errors[:base].should be_empty

      @status.day_of_week = nil
      @status.day         = Date.today
      @status.valid?
      # @status.should have(:no).errors_on(:base)
      @status.errors[:base].should be_empty
    end

    it "should validate that status is a valid status" do
      Status::VALID_STATUSES.should be_kind_of(Array)

      Status::VALID_STATUSES.each do |status|
        @status.status = status
        @status.valid?
        # @status.should have(:no).errors_on(:status)
        @status.errors[:status].should be_empty
      end

      %w(foo bar bam baz).each do |status|
        @status.status = status
        @status.valid?
        # @status.should have_at_least(1).error_on(:status)
        @status.errors[:status].size.should be >= 1
      end
    end
  end

  describe "scopes" do
    describe ".default" do
      before(:each) do
        @sunday_default  = Status.make(:day_of_week => 0,    :start_time => '09:00', :end_time => '17:00')
        @sunday_override = Status.make(:day => '2009-11-22', :start_time => '08:00', :end_time => '16:00')
      end

      it "should include default statuses" do
        Status.default.all.should include(@sunday_default)
      end

      it "should not include overrides" do
        Status.default.all.should_not include(@sunday_override)
      end
    end

    describe ".override" do
      before(:each) do
        @sunday_default  = Status.make(:day_of_week => 0,    :start_time => '09:00', :end_time => '17:00')
        @sunday_override = Status.make(:day => '2009-11-22', :start_time => '08:00', :end_time => '16:00')
      end

      it "should include overrides" do
        Status.override.all.should include(@sunday_override)
      end

      it "should not include default statuses" do
        Status.override.all.should_not include(@sunday_default)
      end
    end
  end

  describe "class methods" do
    describe ".for" do
      before(:each) do
        @sunday_default    = Status.make(:day_of_week => 0,    :start_time => '09:00', :end_time => '17:00')
        @monday_default    = Status.make(:day_of_week => 1,    :start_time => '06:00', :end_time => '14:00')
        @monday_default_2  = Status.make(:day_of_week => 1,    :start_time => '16:00', :end_time => '23:00')
        @sunday_override   = Status.make(:day => '2009-11-22', :start_time => '06:00', :end_time => '14:00')
        @sunday_override_2 = Status.make(:day => '2009-11-22', :start_time => '16:00', :end_time => '23:00')
      end

      describe "with only one parameter (= day)" do
        it "should include the overrides if at least one override is defined for the given day" do
          statuses = Status.for(Date.civil(2009, 11, 22))
          statuses.should have(2).items
          statuses.should include(@sunday_override)
          statuses.should include(@sunday_override_2)
        end

        it "should not include the defaults if at least one override is defined for the given day" do
          Status.for(Date.civil(2009, 11, 22)).should_not include(@sunday_default)
        end

        it "should set the :day for default statuses" do
          statuses = Status.for(Date.civil(2009, 11, 23))
          statuses.should have(2).items
          statuses.map(&:day).should_not include(nil)
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
          statuses[start_date].should have(2).items
          statuses[end_date].should have(2).items

          statuses[start_date].should include(@sunday_override)
          statuses[start_date].should include(@sunday_override_2)
          statuses[end_date].should   include(@monday_default)
          statuses[end_date].should   include(@monday_default_2)
        end

        it "should set the :day for default statuses" do
          start_date = Date.civil(2009, 11, 23)
          end_date   = Date.civil(2009, 11, 30)

          statuses = Status.for(start_date, end_date)
          statuses[start_date].map(&:day).should == [start_date, start_date]
          statuses[end_date].map(&:day).should == [end_date, end_date]
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

    describe ".fill_gaps!" do
      before(:each) do
        @employee = Employee.make
      end

      it "should fill up a gap during the day" do
        statuses = Status.fill_gaps!(@employee, 0, [
          Status.new(:day_of_week => 0, :start_time => '00:00', :end_time => '12:00'),
          Status.new(:day_of_week => 0, :start_time => '17:00', :end_time => '00:00')
        ])
        statuses.size.should == 3
        statuses[1].start_time.strftime('%H:%M').should == '12:00'
        statuses[1].end_time.strftime('%H:%M').should   == '17:00'
      end

      describe "with empty array / nil" do
        it "should return an array with one full day status if nil given" do
          statuses = Status.fill_gaps!(@employee, 0, nil)
          statuses.size.should == 1
          statuses.first.start_time.strftime('%H:%M').should == '00:00'
          statuses.first.end_time.strftime('%H:%M').should   == '00:00'
        end

        it "should return an array with one full day status if empty array given" do
          statuses = Status.fill_gaps!(@employee, 0, [])
          statuses.size.should == 1
          statuses.first.start_time.strftime('%H:%M').should == '00:00'
          statuses.first.end_time.strftime('%H:%M').should   == '00:00'
        end
      end

      describe "filling up gaps until midnight" do
        it "should fill up a gap to midnight" do
          statuses = Status.fill_gaps!(@employee, 0, [Status.new(:day_of_week => 0, :start_time => '00:00', :end_time => '16:00')])
          statuses.size.should == 2
          statuses.last.start_time.strftime('%H:%M').should == '16:00'
          statuses.last.end_time.strftime('%H:%M').should   == '00:00'
        end

        it "should fill up a gap to midnight - with 2 statuses" do
          statuses = Status.fill_gaps!(@employee, 0, [
            Status.new(:day_of_week => 0, :start_time => '00:00', :end_time => '14:00'),
            Status.new(:day_of_week => 0, :start_time => '14:00', :end_time => '16:00')
          ])
          statuses.size.should == 3
          statuses.last.start_time.strftime('%H:%M').should == '16:00'
          statuses.last.end_time.strftime('%H:%M').should   == '00:00'
        end
      end

      describe "filling up gaps from midnight" do
        it "should fill up a gap from midnight" do
          statuses = Status.fill_gaps!(@employee, 0, [Status.new(:day_of_week => 0, :start_time => '16:00', :end_time => '00:00')])
          statuses.size.should == 2
          statuses.first.start_time.strftime('%H:%M').should == '00:00'
          statuses.first.end_time.strftime('%H:%M').should   == '16:00'
        end

        it "should fill up a gap from midnight - with 2 statuses" do
          statuses = Status.fill_gaps!(@employee, 0, [
            Status.new(:day_of_week => 0, :start_time => '18:00', :end_time => '00:00'),
            Status.new(:day_of_week => 0, :start_time => '16:00', :end_time => '18:00')
          ])
          statuses.size.should == 3
          statuses.first.start_time.strftime('%H:%M').should == '00:00'
          statuses.first.end_time.strftime('%H:%M').should   == '16:00'
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

    describe "default?" do
      it "should be true if status is a default status" do
        status = Status.make(:day_of_week => 1)
        status.should be_default
      end

      it "should be false if status is not a default status" do
        status = Status.make(:day => Date.today)
        status.should_not be_default
      end
    end

    describe "override?" do
      it "should be true if status is an override status" do
        status = Status.make(:day => Date.today)
        status.should be_override
      end

      it "should be false if status is not an override status" do
        status = Status.make(:day_of_week => 1)
        status.should_not be_override
      end
    end

    describe "#form_values_json" do
      before(:each) do
        @employee = Employee.make
      end

      describe "for default status" do
        before(:each) do
          @status = Status.make(
            :employee    => @employee,
            :day_of_week => 1,
            :start_time  => '08:00',
            :end_time    => '16:00',
            :status      => Status::VALID_STATUSES.first
          )
        end

        it "should return the relevant form values as JSON" do
          json = @status.form_values_json

          json.should include("employee_id: #{@employee.id}")
          json.should include("day_of_week: 1")
          json.should include("start_time: '08:00'")
          json.should include("end_time: '16:00'")
          json.should include("status: '#{Status::VALID_STATUSES.first}'")

          json.should include("status_#{Status::VALID_STATUSES.first.underscore}: true")
          Status::VALID_STATUSES[1..-1].each do |status|
            json.should include("status_#{status.underscore}: false")
          end
        end
      end

      describe "for override status" do
        before(:each) do
          @status = Status.make(
            :employee   => @employee,
            :day        => '2010-02-21',
            :start_time => '08:00',
            :end_time   => '16:00',
            :status     => Status::VALID_STATUSES.first
          )
        end

        it "should return the relevant form values as JSON" do
          json = @status.form_values_json

          json.should include("employee_id: #{@employee.id}")
          json.should include("day: '2010-02-21'")
          json.should include("start_time: '08:00'")
          json.should include("end_time: '16:00'")
          json.should include("status: '#{Status::VALID_STATUSES.first}'")

          json.should include("status_#{Status::VALID_STATUSES.first.underscore}: true")
          Status::VALID_STATUSES[1..-1].each do |status|
            json.should include("status_#{status.underscore}: false")
          end
        end
      end
    end
  end
end
