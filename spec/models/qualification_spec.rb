require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Qualification do
  before(:each) do
    @qualification = Qualification.make
  end

  describe "associations" do
    it "should belong to an account" do
      @qualification.should belong_to(:account)
    end

    it "should be associated with employees" do
      @qualification.should have_many(:employee_qualifications)
      @qualification.should have_many(:employees)
    end
  end

  describe "callbacks" do
    describe "#generate_color" do
      it "generates a color dependent on the number of existing qualifications" do
        Qualification.stub!(:maximum).and_return(1)
        qualification = Qualification.make
        qualification.color.should == '#ffcf3f'
      end
    end
  end

  describe "instance methods" do
    describe "#possible_workplaces" do
      before(:each) do
        @cook_qualification         = Qualification.make(:name => 'Cook')
        @receptionist_qualification = Qualification.make(:name => 'Receptionist')
        @barkeeper_qualification    = Qualification.make(:name => 'Barkeeper')

        @kitchen   = Workplace.make(:name => 'Kitchen',   :qualifications => [@cook_qualification])
        @reception = Workplace.make(:name => 'Reception', :qualifications => [@receptionist_qualification])
      end

      it "should return all possible workplaces" do
        @cook_qualification.possible_workplaces.should include(@kitchen)
        @receptionist_qualification.possible_workplaces.should include(@reception)

        @barkeeper_qualification.possible_workplaces.should be_empty
      end
    end

    describe "#form_values_json" do
      before(:each) do
        @cook_qualification = Qualification.make(:name => 'Cook')
      end

      it "should return the relevant form values as JSON" do
        @cook_qualification.form_values_json.should include("name: 'Cook'")
      end
    end
  end
end
