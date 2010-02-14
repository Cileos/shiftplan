require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Workplace do
  before(:each) do
    @workplace = Workplace.make
  end

  describe "associations" do
    it "should belong to an account" do
      @workplace.should belong_to(:account)
    end

    it "should have workplace requirements" do
      @workplace.should have_many(:workplace_requirements)
    end

    it "should have qualifications" do
      @workplace.should have_many(:workplace_qualifications)
      @workplace.should have_many(:qualifications)
    end
  end

  describe "validations" do
    before(:each) do
      @workplace = Workplace.make(:name => 'Kitchen')
    end

    it "should require a name" do
      @workplace.should validate_presence_of(:name)
    end
  end

  describe "scopes" do
    describe ".for_qualification" do
      before(:each) do
        @qualification_1 = Qualification.make
        @qualification_2 = Qualification.make

        @workplace_1 = Workplace.make(
          :name => 'Workplace for qualification 1',
          :workplace_qualifications => [WorkplaceQualification.make(:qualification => @qualification_1)]
        )
        @workplace_2 = Workplace.make(
          :name => 'Workplace for qualification 2',
          :workplace_qualifications => [WorkplaceQualification.make(:qualification => @qualification_2)]
        )
        @workplaces_for_qualification_1 = Workplace.for_qualification(@qualification_1).all
      end

      it "should include workplaces that fit a given qualification" do
        @workplaces_for_qualification_1.should include(@workplace_1)
      end

      it "should not include workplaces that don't fit a given qualification" do
        @workplaces_for_qualification_1.should_not include(@workplace_2)
      end
    end

    describe ".active" do
      before(:each) do
        @active_workplace   = Workplace.make(:name => 'Active workplace',   :active => true)
        @inactive_workplace = Workplace.make(:name => 'Inactive workplace', :active => false)
      end

      it "should include active workplaces" do
        Workplace.active.all.should include(@active_workplace)
      end

      it "should not include inactive workplaces" do
        Workplace.active.all.should_not include(@inactive_workplace)
      end
    end

    describe ".inactive" do
      before(:each) do
        @active_workplace   = Workplace.make(:name => 'Active workplace',   :active => true)
        @inactive_workplace = Workplace.make(:name => 'Inactive workplace', :active => false)
      end

      it "should include inactive workplaces" do
        Workplace.inactive.all.should include(@inactive_workplace)
      end

      it "should not include active workplaces" do
        Workplace.inactive.all.should_not include(@active_workplace)
      end
    end
  end

  describe "callbacks" do
    describe "#generate_color" do
      it "generates a color dependent on the number of existing workplaces" do
        @workplace.send(:generate_color)
        @workplace.color.should == '#ffc58c'

        Workplace.stub!(:count).and_return(1)
        another_workplace = Workplace.new
        another_workplace.send(:generate_color)
        another_workplace.color.should == '#ffc58c'
      end
    end
  end

  describe "class methods" do
    describe ".search" do
      before(:each) do
        @workplace = Workplace.make(:name => 'Kitchen')
      end

      describe "successful" do
        it "should find workplaces that match a given name" do
          Workplace.search('kitchen').should include(@workplace)
        end

        # it "should find workplaces that match a given qualification name" do
        #   Workplace.search('cook').should include(@workplace)
        # end
      end

      describe "unsuccessful" do
        it "should find workplaces that don't match a given name" do
          Workplace.search('bar').should_not include(@workplace)
        end

        # it "should find workplaces that don't match a given qualification name" do
        #   Workplace.search('barkeeper').should_not include(@workplace)
        # end
      end
    end
  end

  describe "instance methods" do
    describe "#state" do
      it "returns 'active' if the workplace is active" do
        @workplace.active = true
        @workplace.state.should == 'active'
      end

      it "returns 'inactive' if the workplace is inactive" do
        @workplace.active = false
        @workplace.state.should == 'inactive'
      end
    end

    describe "#required_quantity_for" do
      before(:each) do
        @cook_qualification = Qualification.make(:name => 'Cook')
        @workplace.workplace_requirements.build(:qualification => @cook_qualification, :quantity => 3)
      end

      it "shows the required quantity for a given qualification" do
        @workplace.required_quantity_for(@cook_qualification).should == 3
      end
    end

    describe "#default_staffing" do
      before(:each) do
        @cook_qualification = Qualification.make(:name => 'Cook')
        @receptionist_qualification = Qualification.make(:name => 'Receptionist')
        WorkplaceRequirement.make(:workplace => @workplace, :quantity => 3, :qualification => @cook_qualification)
        WorkplaceRequirement.make(:workplace => @workplace, :quantity => 2, :qualification => @receptionist_qualification)
      end

      it "shows the workplace's default staffing (ids)" do
        expected = ([@cook_qualification.id] * 3) + ([@receptionist_qualification.id] * 2)
        @workplace.default_staffing.should == expected
      end
    end

    describe "#needs_qualification?" do
      before(:each) do
        @cook_qualification = Qualification.make(:name => 'Cook')
        @receptionist_qualification = Qualification.make(:name => 'Receptionist')
        @workplace.qualifications = [@cook_qualification]
      end

      it "should return true if the workplaces needs the given qualification" do
        @workplace.needs_qualification?(@cook_qualification).should be_true
      end

      it "should return false if the workplaces doesn't need the given qualification" do
        @workplace.needs_qualification?(@receptionist_qualification).should be_false
      end
    end

    describe "#form_values_json" do
      before(:each) do
        @workplace = Workplace.make(
          :name => 'Kitchen',
          :active => true,
          :default_shift_length => 480
        )
        # no qualifications for the sake of simplicity
      end

      it "should return the relevant form values as JSON" do
        json = @workplace.form_values_json

        json.should include("name: 'Kitchen'")
        json.should include("active: true")
        json.should include("default_shift_length: 480")
        json.should include("qualifications: []")
      end
    end

    describe "#workplace_requirements_json" do
      before(:each) do
        @cook_qualification = Qualification.make(:name => 'Cook')
        @workplace_requirement = WorkplaceRequirement.make(:qualification => @cook_qualification, :workplace => @workplace, :quantity => 3)
      end

      it "should return the relevant workplace requirement values as JSON" do
        json = @workplace.workplace_requirements_json

        json.should include("id: #{@workplace_requirement.id}")
        json.should include("id: #{@cook_qualification.id}")
        json.should include("name: 'Cook'")
        json.should include("quantity: 3")
      end
    end
  end
end
