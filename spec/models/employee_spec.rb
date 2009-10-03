require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Employee do
  before(:each) do
    @employee = Employee.new
  end

  describe "associations" do
    it "should have qualifications" do
      @employee.should have_many(:employee_qualifications)
      @employee.should have_many(:qualifications)
    end

    it "should have allocations" do
      @employee.should have_many(:allocations)
    end
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

  describe "instance methods" do
    describe "#full_name" do
      before(:each) do
        @employee.first_name = 'Fritz'
        @employee.last_name = 'Thielemann'
      end

      it "should return the employee's full name" do
        @employee.full_name.should == 'Fritz Thielemann'
      end
    end

    describe "#initials" do
      before(:each) do
        @employee.first_name = 'Fritz Joachim Werner'
        @employee.last_name = 'von Thielemann'
      end

      it "should generate the first of each name part as initials" do
        @employee.initials.should == 'FJWvT'
      end

      it "should use saved initials if set" do
        @employee.initials = 'FT'
        @employee.initials.should == 'FT'
      end
    end

    describe "#state" do
      it "returns 'active' if the workplace is active" do
        @employee.active = true
        @employee.state.should == 'active'
      end

      it "returns 'inactive' if the workplace is inactive" do
        @employee.active = false
        @employee.state.should == 'inactive'
      end
    end

    describe "#has_qualification?" do
      before(:each) do
        @cook_qualification = Qualification.new(:name => 'Cook')
        @receptionist_qualification = Qualification.new(:name => 'Receptionist')
        @employee.qualifications = [@cook_qualification]
      end

      it "should return true if the workplaces needs the given qualification" do
        @employee.should have_qualification(@cook_qualification)
      end

      it "should return false if the workplaces doesn't need the given qualification" do
        @employee.should_not have_qualification(@receptionist_qualification)
      end
    end

    describe "#possible_workplaces" do
      # TODO
    end
  end
end
