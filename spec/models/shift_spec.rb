require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Shift do
  def now
    @now ||= Time.parse('2009-09-09 12:00')
  end

  before(:each) do
    @shift = Shift.new do |s|
      s.workplace_id = 1
      s.start        = now
      s.end          = now + 2.hours
      s.duration     = nil
    end
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
  end

  describe "callbacks" do
    describe "#build_requirements" do
      before(:each) do
        @cook_qualification = Qualification.new(:name => 'Cook')
        @receptionist_qualification = Qualification.new(:name => 'Receptionist')
        @workplace = Workplace.new
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
      it "synchronizes missing duration from start/end time before validation" do
        @shift.duration = nil
        @shift.valid?
        @shift.duration.should == 120
      end

      it "synchronizes missing end time from start time and duration before validation" do
        @shift.duration = 180
        @shift.end = nil
        @shift.valid?
        @shift.end.should == now + 3.hours
      end
    end
  end

  describe "instance methods" do
    describe "start/end/duration related methods" do
      before(:each) do
        @shift.start = Time.local(2009, 9, 9, 23, 0, 0)
        @shift.duration = 120
      end

      it "should show the start in minutes from midnight" do
        @shift.start_in_minutes.should == 23 * 60
      end

      it "calculates end_in_minutes based on start and duration (i.e. might be longer than 24 hours)" do
        @shift.end_in_minutes.should == 23 * 60 + 120
      end
    end

    it "should regard a valid object as valid" do
      @shift.should be_valid
    end

    it "should require a start time" do
      @shift.should validate_presence_of(:start)
    end

    it "should require an end time" do
      @shift.should validate_presence_of(:end)
    end

    it "should have a start time before its end time" do
      @shift.end = now - 2.hours
      @shift.should_not be_valid
      assert @shift.errors.on(:base).include?("Start must be before end")
    end
  end
end
