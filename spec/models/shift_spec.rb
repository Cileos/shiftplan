require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Shift do
  def now
    @now ||= Time.zone.local(2009, 9, 9, 12, 0)
  end

  before(:each) do
    @shift = Shift.new
  end

  describe "associations" do
    it "should belong to a workplace" do
      @shift.should belong_to(:workplace)
    end

    it "should have requirements" do
      @shift.should have_many(:requirements)
    end
  end

  describe "validations" do
    it "should require a valid start" do
      @shift.should validate_presence_of(:start)
    end

    it "should require a valid end" do
      @shift.should validate_presence_of(:end)
    end

    it "should have a start time before its end time" do
      @shift.start = now
      @shift.end   = now - 2.hours

      @shift.should_not be_valid
      # @shift.should have_at_least(1).error_on(:base)
      @shift.errors[:base].should include("Start must be before end")
    end

    # FIXME: not activated at the moment - why?
    # it "should require to be associated to a plan" do
    #   @shift.should validate_presence_of(:plan_id)
    # end
  end

  describe "callbacks" do
    describe "#build_requirements" do
      before(:each) do
        @cook_qualification         = Qualification.make(:name => 'Cook')
        @receptionist_qualification = Qualification.make(:name => 'Receptionist')
        @workplace = Workplace.make
        @workplace.workplace_requirements.build([
          { :qualification => @cook_qualification, :quantity => 3 },
          { :qualification => @receptionist_qualification, :quantity => 2 }
        ])
        @shift.workplace = @workplace
      end

      it "should build the workplace's default requirements" do
        @shift.send(:build_requirements)
        @shift.should have(5).requirements

        attributes = @shift.requirements.map(&:qualification).uniq
        attributes.should include(@cook_qualification)
        attributes.should include(@receptionist_qualification)
      end
    end

    describe "#synchronize_duration_end_time" do
      before(:each) do
        @shift.start = now
        @shift.end   = now + 2.hours
      end

      it "synchronizes missing duration from start/end time before validation" do
        @shift.duration = nil
        @shift.valid? # @shift.send(:synchronize_duration_end_time) # ?
        @shift.duration.should == 120
      end

      it "synchronizes missing end time from start time and duration before validation" do
        @shift.duration = 180
        @shift.end = nil
        @shift.valid? # @shift.send(:synchronize_duration_end_time) # ?
        @shift.end.should == now + 3.hours
      end
    end
  end

  describe "instance methods" do
    describe "start/end/duration related methods" do
      before(:each) do
        @shift.start = Time.zone.local(2009, 9, 9, 23, 0, 0)
        @shift.duration = 120
      end

      it "should show the day" do
        @shift.day.should == Date.civil(2009, 9, 9)
      end

      it "should show the start in minutes from midnight" do
        @shift.start_in_minutes.should == 23 * 60
      end

      it "calculates end_in_minutes based on start and duration (i.e. might be longer than 24 hours)" do
        @shift.end_in_minutes.should == 23 * 60 + 120
      end
    end

    describe "updating start/end attributes" do
      it "should update start/end attributes" do
        # ???
        shift = Shift.make(:start => Time.zone.now, :end => Time.zone.now + 2.hours, :duration => 120)

        start_time = Time.zone.parse('Mon Sep 07 08:00:00 +0200 2009')
        end_time   = Time.zone.parse('Mon Sep 07 11:00:00 +0200 2009')
        attributes = { "start" => start_time, "end" => end_time, "workplace_id" => "2" }

        shift.update_attributes!(attributes)
        shift.reload

        shift.start.should == start_time
        shift.end.should == end_time
        shift.duration.should == 180
      end
    end

    describe "#available_employee_ids" do
      before(:each) do
        @shift       = Shift.make(:start => Time.zone.local(2009, 11, 30, 8, 0), :end => Time.zone.local(2009, 11, 30, 17, 0))
        @employee_1  = Employee.make
        @employee_2  = Employee.make
      end

      Status::VALID_STATUSES.each do |status|
        { :day_of_week => 1, :day => Date.civil(2009, 11, 30) }.each do |key, value|
          describe "with #{key == :day ? 'overridden' : 'default'} status #{status.inspect}" do
            before(:each) do
              @attributes = { key => value, :status => status }
            end

            it "should return available employees with overlapping availability times" do
              Status.make({ :employee => @employee_1, :start_time => '8:00', :end_time => '17:00' }.reverse_merge(@attributes))
              @shift.statused_employee_ids(status).should include(@employee_1.id)
            end

            it "should return available employees with larger than necessary availability times" do
              Status.make({ :employee => @employee_1, :start_time => '7:00', :end_time => '18:00' }.reverse_merge(@attributes))
              Status.make({ :employee => @employee_2, :start_time => '0:00', :end_time => '23:00' }.reverse_merge(@attributes))
              @shift.statused_employee_ids(status).should include(@employee_1.id)
              @shift.statused_employee_ids(status).should include(@employee_2.id)
            end

            it "should not return available employees with wrong availability times" do
              Status.make({ :employee => @employee_1, :start_time => '9:00', :end_time => '18:00' }.reverse_merge(@attributes))
              Status.make({ :employee => @employee_2, :start_time => '7:00', :end_time => '16:00' }.reverse_merge(@attributes))
              @shift.statused_employee_ids(status).should be_empty
            end

            it "should not return employees with no availability times" do
              @shift.statused_employee_ids(status).should be_empty
            end
          end
        end
      end
    end
  end
end
