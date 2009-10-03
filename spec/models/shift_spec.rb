require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Shift do
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
  end

  describe "instance methods" do
    describe "start/end/duration related methods" do
      before(:each) do
        @shift.start = Time.local(2009, 10, 3, 12, 0, 0)
        @shift.end   = Time.local(2009, 10, 3, 13, 0, 0)
      end

      it "should calculate the duration in seconds" do
        @shift.duration.should == 3600
      end

      it "should calculate the duration in minutes" do
        @shift.duration_in_minutes.should == 60
      end

      it "should show the start in minutes from midnight" do
        @shift.start_in_minutes.should == 720
      end

      it "should show the end in minutes from midnight" do
        @shift.end_in_minutes.should == 780
      end

      it "should show the start's date" do
        @shift.day.should == Date.civil(2009, 10, 3)
      end
    end
  end
end
