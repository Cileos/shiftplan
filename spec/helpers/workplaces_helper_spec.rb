require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WorkplacesHelper do
  describe "#requirement_list" do
    before(:each) do
      @cook_qualification = Qualification.new(:name => 'Cook')
      @receptionist_qualification = Qualification.new(:name => 'Receptionist')
      @workplace = Workplace.new
      @workplace.workplace_requirements.build([
        { :qualification => @cook_qualification, :quantity => 3 },
        { :qualification => @receptionist_qualification, :quantity => 2 }
      ])
    end

    it "should return a list of all a given workplace's requirements (truncated to 20 characters by default)" do
      helper.requirement_list(@workplace).should == '3x Cook, 2x Recep...'
    end

    it "should return a list of all a given workplace's requirements (truncated)" do
      helper.requirement_list(@workplace, :length => 15).should == '3x Cook, 2x ...'
    end

    it "should return a list of all a given workplace's requirements (not truncated)" do
      helper.requirement_list(@workplace, :truncate => false).should == '3x Cook, 2x Receptionist'
    end
  end
end
