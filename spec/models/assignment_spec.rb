require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Assignment do
  before(:each) do
    @assignment = Assignment.new
  end

  describe "associations" do
    it "should reference an employee" do
      @assignment.should belong_to(:employee)
    end

    it "should reference a requirement" do
      @assignment.should belong_to(:requirement)
    end
  end
end
