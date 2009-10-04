require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Qualification do
  before(:each) do
    @qualification = Qualification.new
  end

  describe "associations" do
    it "should be associated with employees" do
      @qualification.should have_many(:employee_qualifications)
      @qualification.should have_many(:employees)
    end
  end

  describe "callbacks" do
    describe "#generate_color" do
      it "generates a color dependent on the number of existing qualifications" do
        @qualification.send(:generate_color)
        @qualification.color.should == '#ff6f3f'

        Qualification.stub!(:maximum).and_return(1)
        another_qualification = Workplace.new
        another_qualification.send(:generate_color)
        another_qualification.color.should == '#ff8c8c'
      end
    end
  end

  describe "instance methods" do
    describe "#possible_workplaces" do
      before(:each) do
        @cook_qualification = Qualification.create!(:name => 'Cook')
        @receptionist_qualification = Qualification.create!(:name => 'Receptionist')
        @barkeeper_qualification = Qualification.create!(:name => 'Barkeeper')

        @kitchen = Workplace.create!(:name => 'Kitchen', :qualifications => [@cook_qualification])
        @reception = Workplace.create!(:name => 'Reception', :qualifications => [@receptionist_qualification])
      end

      it "should return all possible workplaces" do
        @cook_qualification.possible_workplaces.should include(@kitchen)
        @receptionist_qualification.possible_workplaces.should include(@reception)

        @barkeeper_qualification.possible_workplaces.should be_empty
      end
    end
  end
end
