require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Assignment do
  before(:each) do
    @assignment = Assignment.make
  end

  describe "associations" do
    it "should reference an employee" do
      @assignment.should belong_to(:assignee)
    end

    it "should reference a requirement" do
      @assignment.should belong_to(:requirement)
    end
  end

  describe "validations" do
    it "should require to be associated to a requirement" do
      @assignment.should validate_presence_of(:requirement_id)
    end

    it "should require to be associated to an assignee" do
      @assignment.should validate_presence_of(:assignee_id)
    end
  end
end
