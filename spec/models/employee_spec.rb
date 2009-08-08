require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Employee do
  before(:each) do
    @employee = Employee.new
  end

  describe "validations" do
    before(:each) do
      @employee.attributes = {
        :first_name => "Fritz",
        :last_name => "Thielemann"
      }
    end

    it "should regard a valid object as valid" do
      @employee.should be_valid
    end

    it "should require a first name" do
      @employee.should validate_presence_of(:first_name)
    end

    it "should require a last name" do
      @employee.should validate_presence_of(:last_name)
    end
  end
end
