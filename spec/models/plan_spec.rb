require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Plan do
  def monday
    @monday ||= Time.zone.local(2009, 9, 7).to_date
  end

  def friday
    @friday ||= Time.zone.local(2009, 9, 11).to_date
  end

  def monday_morning
    @monday_morning ||= Time.zone.local(2009, 9, 7, 8, 30)
  end

  def friday_afternoon
    @friday_afternoon ||= Time.zone.local(2009, 9, 11, 16, 30)
  end

  before(:each) do
    @plan = Plan.make
  end

  describe "associations" do
    it "should belong to an account" do
      @plan.should belong_to(:account)
    end

    it "should have shifts" do
      @plan.should have_many(:shifts)
    end
  end

  describe "validations" do
    it "should require a start date" do
      @plan.should validate_presence_of(:start_date)
    end

    it "should require an end date" do
      @plan.should validate_presence_of(:end_date)
    end

    it "should require a start time" do
      @plan.should validate_presence_of(:start_time)
    end

    it "should require an end time" do
      @plan.should validate_presence_of(:end_time)
    end

    it "validates start_date < end_date" do
      @plan.start_date = Time.zone.parse('2010-01-02').to_date
      @plan.end_date   = Time.zone.parse('2010-01-02').to_date
      @plan.valid?.should be_false
      @plan.errors[:base].should include('Start date must be before end date')
    end

    it "validates start_time < end_time" do
      @plan.start_time = Time.zone.parse('12:00:00')
      @plan.end_time   = Time.zone.parse('11:00:00')
      @plan.valid?.should be_false
      @plan.errors[:base].should include('Start time must be before end time')
    end
  end

  describe "instance methods" do
    before(:each) do
      @plan = Plan.make(:start_date => monday, :end_date => friday, :start_time => monday_morning, :end_time => friday_afternoon)
      @plan.reload
    end

    describe "#days" do
      it "should calculate duration from start/end time" do
        @plan.duration.should == 8 * 60
      end

      it "should return a range of days from start day to end day" do
        @plan.days.should == (Time.zone.local(2009, 9, 7).to_date..Time.zone.local(2009, 9, 11).to_date)
      end
    end

    describe "#start_time_in_minutes" do
      it "should return the start time in minutes" do
        @plan.start_time_in_minutes.should == 8 * 60 + 30
      end
    end

    describe "#end_time_in_minutes" do
      it "should return the end time in minutes" do
        @plan.end_time_in_minutes.should == 16 * 60 + 30
      end
    end

    describe "#copy_from" do
      before(:each) do
        monday = self.monday # - 149.days
        friday = self.friday # - 149.days

        requirement = Requirement.make(:qualification => Qualification.make, :assignment => Assignment.make)
        shift       = Shift.make :requirements => [requirement],
                                 :start => monday_morning,
                                 :end   => monday_morning + 8.hours

        @template   = Plan.make :start_date => monday,
                                :end_date   => friday,
                                :start_time => monday_morning,
                                :end_time   => friday_afternoon,
                                :template   => true,
                                :shifts     => [shift]
      end

      it "should copy shifts" do
        @plan.copy_from(@template)
        @plan.save!

        shift = @plan.shifts.first
        shift.id.should_not be_nil
        shift.id.should_not == @template.shifts.first.id
        shift.start.to_date.should == monday
        shift.end.to_date.should   == monday

        shift.requirements.should be_empty
      end

      it "does not copy shifts if their adjusted date is greater than the plan's end_date" do
        shift = @template.shifts.first
        shift.update_attributes!(:start => shift.start + 7.days, :end => shift.end + 7.days)

        @plan.copy_from(@template)
        @plan.shifts.should be_empty
      end

      it "should copy requirements if requested" do
        @plan.copy_from(@template, :copy => %w(requirements))
        @plan.save!

        requirement = @plan.shifts.first.requirements.first
        requirement.id.should_not be_nil
        requirement.id.should_not == @template.shifts.first.requirements.first.id
      end

      it "should copy assignments if requested" do
        @plan.copy_from(@template, :copy => %w(requirements assignments))
        @plan.save!

        assignment = @plan.shifts.first.requirements.first.assignment
        assignment.id.should_not be_nil
        assignment.id.should_not == @template.shifts.first.requirements.first.assignment.id
      end
    end
  end
end
