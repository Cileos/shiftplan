require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WorkplaceRequirement do
  before(:each) do
    @workplace_requirement = WorkplaceRequirement.make
  end

  describe "associations" do
    it "should reference a workplace" do
      @workplace_requirement.should belong_to(:workplace)
    end

    it "should reference a qualification" do
      @workplace_requirement.should belong_to(:qualification)
    end
  end

  describe "validations" do
    it "should require to be associated to a workplace" do
      @workplace_requirement.should validate_presence_of(:workplace_id)
    end

    it "should require to be associated to a qualification" do
      @workplace_requirement.should validate_presence_of(:qualification_id)
    end
  end
end
