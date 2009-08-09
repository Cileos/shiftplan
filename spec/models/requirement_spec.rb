require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Requirement do
  before(:each) do
    @requirement = Requirement.new
  end

  describe "validations" do
    before(:each) do
      @requirement.attributes = {
        :workplace_id => 1,
        :start => Time.now,
        :end => 2.hours.from_now,
        :quantity => 1
      }
    end

    it "should regard a valid object as valid" do
      @requirement.should be_valid
    end

    it "should require a quantity" do
      @requirement.should validate_presence_of(:quantity)
    end

    it "should require a workplace" do
      @requirement.should validate_presence_of(:workplace_id)
    end

    it "should require a start time" do
      @requirement.should validate_presence_of(:start)
    end

    it "should require an end time" do
      @requirement.should validate_presence_of(:end)
    end

    it "should have a start time before its end time" do
      @requirement.end = 2.hours.ago
      @requirement.should_not be_valid
    end
  end
end
