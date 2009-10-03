require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WorkplaceQualification do
  before(:each) do
    @workplace_qualification = WorkplaceQualification.new
  end

  describe "associations" do
    it "should reference a workplace" do
      @workplace_qualification.should belong_to(:workplace)
    end

    it "should reference a qualification" do
      @workplace_qualification.should belong_to(:qualification)
    end
  end
end
