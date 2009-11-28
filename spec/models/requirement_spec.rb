require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Requirement do
  before(:each) do
    @requirement = Requirement.new
  end

  describe "associations" do
    it "should belong to a shift" do
      @requirement.should belong_to(:shift)
    end

    it "should reference a qualification" do
      @requirement.should belong_to(:qualification)
    end

    it "should have an assignment" do
      @requirement.should have_one(:assignment)
    end
  end

  describe "validations" do
    before(:each) do
      @requirement.attributes = {}
    end

    it "should regard a valid object as valid" do
      @requirement.should be_valid
    end
  end

  describe "instance methods" do
    describe "#fulfilled?" do
      it "should be fulfilled if an assignment is present" do
        @requirement.assignment = Assignment.make
        @requirement.should be_fulfilled
      end

      it "should not be fulfilled if no assignment is present" do
        @requirement.assignment = nil
        @requirement.should_not be_fulfilled
      end
    end
  end
end
