require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Workplace do
  before(:each) do
    @workplace = Workplace.new
  end

  describe "associations" do
    it "should belong to an account" do
      @workplace.should belong_to(:account)
    end

    it "should belong to a location" do
      @workplace.should belong_to(:location)
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
      @workplace.attributes = {
        :name => 'Kitchen'
      }
    end

    it "should require a name" do
      @workplace.should validate_presence_of(:name)
    end
  end

  describe "scopes" do
    describe ".for_qualification" do
      before(:each) do
        @scope_options = Workplace.for_qualification(mock_model(Qualification, :id => 1)).proxy_options
      end

      it "should return all workplaces that fit a given qualification" do
        @scope_options[:joins].should == :workplace_qualifications
        @scope_options[:conditions].should == ["qualification_id = ?", 1]
      end
    end

    describe ".active/.inactive" do
      before(:each) do
        @active_scope_options = Workplace.active.proxy_options
        @inactive_scope_options = Workplace.inactive.proxy_options
      end

      it "should return all active workplaces" do
        @active_scope_options[:conditions].should == { :active => true }
      end

      it "should return all inactive workplaces" do
        @inactive_scope_options[:conditions].should == { :active => false }
      end
    end
  end

  describe "callbacks" do
    describe "#generate_color" do
      it "generates a color dependent on the number of existing workplaces" do
        @workplace.send(:generate_color)
        @workplace.color.should == '#ff8c8c'

        Workplace.stub!(:count).and_return(1)
        another_workplace = Workplace.new
        another_workplace.send(:generate_color)
        another_workplace.color.should == '#ffc58c'
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
        @cook_qualification = mock_model(Qualification, :id => 1, :name => 'Cook')
        @workplace.workplace_requirements.build(:qualification => @cook_qualification, :quantity => 3)
      end

      it "shows the required quantity for a given qualification" do
        @workplace.required_quantity_for(@cook_qualification).should == 3
      end
    end

    describe "#required_quantity_for" do
      before(:each) do
        @cook_qualification = mock_model(Qualification, :id => 1, :name => 'Cook')
        @receptionist_qualification = mock_model(Qualification, :id => 2, :name => 'Receptionist')
        @workplace.workplace_requirements.build([
          { :qualification => @cook_qualification, :quantity => 3 },
          { :qualification => @receptionist_qualification, :quantity => 2 }
        ])
      end

      it "shows the workplace's default staffing (ids)" do
        @workplace.default_staffing.should == [1, 1, 1, 2, 2]
      end
    end

    describe "#needs_qualification?" do
      before(:each) do
        @cook_qualification = Qualification.new(:name => 'Cook')
        @receptionist_qualification = Qualification.new(:name => 'Receptionist')
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
        @workplace.attributes = {
          :name => 'Kitchen',
          :active => true,
          :default_shift_length => 480
        }
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
        @cook_qualification = mock_model(Qualification, :id => 1, :name => 'Cook')
        @workplace.workplace_requirements.build(:qualification => @cook_qualification, :quantity => 3)
        @workplace.workplace_requirements.last.stub!(:id).and_return(2) # yuck
      end

      it "should return the relevant workplace requirement values as JSON" do
        json = @workplace.workplace_requirements_json

        json.should include("id: 2")
        json.should include("id: 1")
        json.should include("name: 'Cook'")
        json.should include("quantity: 3")
      end
    end
  end
end
