require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Employee do
  before(:each) do
    @employee = Employee.make
  end

  describe "associations" do
    it "should have tags" do
      @employee.should have_many(:tags)
      @employee.should have_many(:taggings)
    end

    it "should have qualifications" do
      @employee.should have_many(:employee_qualifications)
      @employee.should have_many(:qualifications)
    end

    it "should have allocations" do
      @employee.should have_many(:allocations)
    end

    it "should have statuses" do
      @employee.should have_many(:statuses)
    end
  end

  describe "validations" do
    it "should require a first name" do
      @employee.should validate_presence_of(:first_name)
    end

    it "should require a last name" do
      @employee.should validate_presence_of(:last_name)
    end
  end

  describe "scopes" do
    describe ".for_qualification" do
      it "should return all employees with the given qualification" do
        @cook_qualification         = Qualification.make(:name => 'Cook')
        @barkeeper_qualification    = Qualification.make(:name => 'Barkeeper')
        @cook_1    = Employee.make(:qualifications => [@cook_qualification])
        @cook_2    = Employee.make(:qualifications => [@cook_qualification])
        @barkeeper = Employee.make(:qualifications => [@barkeeper_qualification])

        cooks = Employee.for_qualification(@cook_qualification).all
        cooks.should     include(@cook_1)
        cooks.should     include(@cook_2)
        cooks.should_not include(@barkeeper)

        barkeepers = Employee.for_qualification(@barkeeper_qualification).all
        barkeepers.should     include(@barkeeper)
        barkeepers.should_not include(@cook_1)
        barkeepers.should_not include(@cook_2)
      end
    end
  end

  describe "class methods" do
    describe ".search" do
      before(:each) do
        @employee = Employee.make(:first_name => 'Fritz', :last_name => 'Thielemann', :tag_list => 'cool, dude')
      end

      describe "successful" do
        it "should find employees that match a given first name" do
          Employee.search('fritz').should include(@employee)
        end

        it "should find employees that match a given last name" do
          Employee.search('thielemann').should include(@employee)
        end

        it "should find employees that match a given tag" do
          Employee.search('dude').should include(@employee)
        end

        # it "should find employees that match a given qualification name" do
        #   Employee.search('cook').should include(@employee)
        # end
        # 
        # it "should find employees that match a given workplace name" do
        #   Employee.search('kitchen').should include(@employee)
        # end
      end

      describe "unsuccessful" do
        it "should not find employees that don't match a given first name" do
          Employee.search('sven').should_not include(@employee)
        end

        it "should not find employees that don't match a given last name" do
          Employee.search('fuchs').should_not include(@employee)
        end

        it "should not find employees that don't match a given tag" do
          Employee.search('uncool').should_not include(@employee)
        end

        # it "should not find employees that don't match a given qualification name" do
        #   Employee.search('barkeeper').should_not include(@employee)
        # end
        # 
        # it "should not find employees that don't match a given workplace name" do
        #   Employee.search('bar').should_not include(@employee)
        # end
      end
    end
  end

  describe "instance methods" do
    describe "#full_name" do
      before(:each) do
        @employee = Employee.make(:first_name => 'Fritz', :last_name => 'Thielemann')
      end

      it "should return the employee's full name" do
        @employee.full_name.should == 'Fritz Thielemann'
      end
    end

    describe "#initials" do
      before(:each) do
        @employee = Employee.make(:first_name => 'Fritz Joachim Werner', :last_name => 'von Thielemann')
      end

      it "should generate the first of each name part as initials" do
        @employee.initials.should == 'FJWvT'
      end

      it "should use saved initials if set" do
        @employee.initials = 'FT'
        @employee.initials.should == 'FT'
      end

      it "should cache the initials" do # stupid test as it tests implementation?
        @employee.initials = 'FT'
        @employee.initials.should == 'FT'
        @employee.initials = 'FT2'
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
        @cook_qualification = Qualification.make(:name => 'Cook')
        @receptionist_qualification = Qualification.make(:name => 'Receptionist')
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
        @cook_qualification         = Qualification.make(:name => 'Cook')
        @receptionist_qualification = Qualification.make(:name => 'Receptionist')
        @barkeeper_qualification    = Qualification.make(:name => 'Barkeeper')

        @kitchen   = Workplace.make(:name => 'Kitchen',   :qualifications => [@cook_qualification])
        @reception = Workplace.make(:name => 'Reception', :qualifications => [@receptionist_qualification])

        @employee_1 = Employee.make(:qualifications => [@cook_qualification, @receptionist_qualification])
        @employee_2 = Employee.make(:qualifications => [@barkeeper_qualification])
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

    describe "#form_values_json" do
      before(:each) do
        @employee = Employee.make(
          :first_name => 'Fritz', :last_name => 'Thielemann', :birthday => Date.civil(1965, 2, 1),
          :email => 'fritz@thielemann.de', :phone => '1234',
          :street => 'Some street 1', :zipcode => '12345', :city => 'Somewhere',
          :tag_list => 'cool, dude', :active => true
        )
        # no qualifications to make life a bit simpler
      end

      it "should return the relevant form values as JSON" do
        json = @employee.form_values_json

        json.should include("first_name: 'Fritz'")
        json.should include("last_name: 'Thielemann'")
        json.should include("email: 'fritz@thielemann.de'")
        json.should include("phone: '1234'")
        json.should include("street: 'Some street 1'")
        json.should include("zipcode: '12345'")
        json.should include("city: 'Somewhere'")
        json.should include("birthday_1i: '1965'")
        json.should include("birthday_2i: '2'")
        json.should include("birthday_3i: '1'")
        json.should include("tag_list: 'cool, dude'")
        json.should include("active: true")
        json.should include("qualifications: []")
      end
    end
  end
end
