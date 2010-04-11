require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Requirement do
  before(:each) do
    @requirement = Requirement.make
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
    # FIXME: not activated at the moment - why?
    # it "should require to be associated to a shift" do
    #   @requirement.should validate_presence_of(:shift_id)
    # end
    #
    # it "should require to be associated to a qualification" do
    #   @requirement.should validate_presence_of(:qualification_id)
    # end
  end

  describe "instance methods" do
    describe "#qualified_employee_ids" do
      before(:each) do
        @cook_qualification      = Qualification.make(:name => 'Cook')
        @barkeeper_qualification = Qualification.make(:name => 'Barkeeper')

        @kitchen_shift    = Shift.make(:start => Time.zone.local(2009, 11, 30, 8, 0), :end => Time.zone.local(2009, 11, 30, 17, 0))
        @cook_requirement = Requirement.make(:shift => @kitchen_shift, :qualification => @cook_qualification)

        @cook_1    = Employee.make(:qualifications => [@cook_qualification])
        @cook_2    = Employee.make(:qualifications => [@cook_qualification])
        @barkeeper = Employee.make(:qualifications => [@barkeeper_qualification])
      end

      it "should include the qualified employees' ids" do
        @cook_requirement.qualified_employee_ids.should include(@cook_1.id, @cook_2.id)
      end

      it "should not include the unqualified employees' ids" do
        @cook_requirement.qualified_employee_ids.should_not include(@barkeeper.id)
      end
    end

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

  describe "delegates" do
    before(:each) do
      @requirement = Requirement.make
    end

    [:day, :start, :end].each do |method|
      it "should delegate :#{method} to its shift" do
        @requirement.send(method).should == @requirement.shift.send(method)
      end
    end
  end
end
