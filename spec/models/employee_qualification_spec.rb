require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EmployeeQualification do
  before(:each) do
    @employee_qualification = EmployeeQualification.make
  end

  describe "associations" do
    it "should reference an employee" do
      @employee_qualification.should belong_to(:employee)
    end

    it "should reference a qualification" do
      @employee_qualification.should belong_to(:qualification)
    end
  end

  describe "validations" do
    it "should require to be associated to an employee" do
      @employee_qualification.should validate_presence_of(:employee_id)
    end

    it "should require to be associated to a qualification" do
      @employee_qualification.should validate_presence_of(:qualification_id)
    end
  end
end
