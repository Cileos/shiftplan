require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Workplace do
  before(:each) do
    @workplace = Workplace.new
  end

  describe "validations" do
    it "should require a name" do
      @workplace.should validate_presence_of(:name)
    end
  end
end
