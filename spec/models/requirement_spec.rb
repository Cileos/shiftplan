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
    it "should require to be associated to a shift" do
      @requirement.should validate_presence_of(:shift_id)
    end

    # it "should require to be associated to a qualification" do
    #   @requirement.should validate_presence_of(:qualification_id)
    # end
  end

  describe "instance methods" do
    describe "#suitable_employees" do
      before(:each) do
        @cook_qualification      = Qualification.make(:name => 'Cook')
        @barkeeper_qualification = Qualification.make(:name => 'Barkeeper')

        @kitchen_shift = Shift.make(:start => Time.local(2009, 11, 30, 8, 0), :end => Time.local(2009, 11, 30, 17, 0))
        @cook_requirement = Requirement.make(:shift => @kitchen_shift, :qualification => @cook_qualification)

        @cook_1    = Employee.make(:qualifications => [@cook_qualification])
        @cook_2    = Employee.make(:qualifications => [@cook_qualification])
        @barkeeper = Employee.make(:qualifications => [@barkeeper_qualification])
      end

      { :day_of_week => 1, :day => Date.civil(2009, 11, 30) }.each do |key, value|
        describe "with #{key == :day ? 'specific' : 'default'} statuses" do
          before(:each) do
            @status = Status::VALID_STATUSES.first
            @default_attributes = { key => value, :status => @status }
          end

          it "should return suitable employees with overlapping availability times" do
            Status.make({ :employee => @cook_1,    :start => '8:00', :end => '17:00' }.reverse_merge(@default_attributes))
            Status.make({ :employee => @cook_2,    :start => '8:00', :end => '17:00' }.reverse_merge(@default_attributes))
            Status.make({ :employee => @barkeeper, :start => '8:00', :end => '17:00' }.reverse_merge(@default_attributes))

            employees = @cook_requirement.suitable_employees(@status)
            employees.should     include(@cook_1)
            employees.should     include(@cook_2)
            employees.should_not include(@barkeeper)
          end

          it "should return suitable employees with larger than necessary availability times" do
            Status.make({ :employee => @cook_1, :start => '7:00', :end => '18:00' }.reverse_merge(@default_attributes))
            Status.make({ :employee => @cook_2, :start => '0:00', :end => '23:00' }.reverse_merge(@default_attributes))

            employees = @cook_requirement.suitable_employees(@status)
            employees.should     include(@cook_1)
            employees.should     include(@cook_2)
            employees.should_not include(@barkeeper)
          end

          it "should not return suitable employees with wrong availability times" do
            Status.make({ :employee => @cook_1, :start => '9:00', :end => '18:00' }.reverse_merge(@default_attributes))
            Status.make({ :employee => @cook_2, :start => '7:00', :end => '16:00' }.reverse_merge(@default_attributes))

            @cook_requirement.suitable_employees(@status).should be_empty
          end

          it "should not return suitable employees with no availability times" do
            @cook_requirement.suitable_employees(@status).should be_empty
          end
        end
      end

      describe "with overridden statuses" do
        before(:each) do
          @status = Status::VALID_STATUSES.first
        end

        it "should return an employee that isn't available by default but is available on a specific day" do
          Status.make(:employee => @cook_1, :day_of_week => 1, :start => '14:00', :end => '23:00', :status => @status)
          Status.make(:employee => @cook_1, :day => Date.civil(2009, 11, 30), :start => '8:00', :end => '17:00', :status => @status)

          @cook_requirement.suitable_employees(@status).should include(@cook_1)
        end

        it "should not return an employee that is available by default but isn't available on a specific day" do
          Status.make(:employee => @cook_1, :day_of_week => 1, :start => '8:00', :end => '17:00', :status => @status)
          Status.make(:employee => @cook_1, :day => Date.civil(2009, 11, 30), :start => '14:00', :end => '23:00', :status => @status)

          @cook_requirement.suitable_employees(@status).should_not include(@cook_1)
        end
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
