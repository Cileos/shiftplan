require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WorkplaceRequirement do
  before(:each) do
    @workplace_requirement = WorkplaceRequirement.new
  end

  describe "associations" do
    it "should reference a workplace" do
      @workplace_requirement.should belong_to(:workplace)
    end

    it "should reference a qualification" do
      @workplace_requirement.should belong_to(:qualification)
    end
  end
end
