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
      before(:each) do
        @cook_qualification = Qualification.create!(:name => 'Cook')
        @receptionist_qualification = Qualification.create!(:name => 'Receptionist')
        @barkeeper_qualification = Qualification.create!(:name => 'Barkeeper')

        @kitchen = Workplace.create!(:name => 'Kitchen', :qualifications => [@cook_qualification])
        @reception = Workplace.create!(:name => 'Reception', :qualifications => [@receptionist_qualification])

        @employee_1 = Employee.new(:qualifications => [@cook_qualification, @receptionist_qualification])
        @employee_1.save(false)
        @employee_2 = Employee.new(:qualifications => [@barkeeper_qualification])
        @employee_2.save(false)
      end

      it "should return all possible workplaces" do
        @employee_1.possible_workplaces.should include(@kitchen)
        @employee_1.possible_workplaces.should include(@reception)

        @employee_2.possible_workplaces.should be_empty
      end
    end

    describe "#gravatar_url_for_css" do # temporary?
      it "should replace &amp; with & so CSS doesn't complain" do
        @employee.stub!(:gravatar_url).and_return('foo&amp;bar')
        @employee.gravatar_url_for_css.should == 'foo&bar'
      end
    end
  end
end
