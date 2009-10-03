require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EmployeeQualification do
  before(:each) do
    @employee_qualification = EmployeeQualification.new
  end

  describe "associations" do
    it "should reference an employee" do
      @employee_qualification.should belong_to(:employee)
    end

    it "should reference a qualification" do
      @employee_qualification.should belong_to(:qualification)
    end
  end
end
