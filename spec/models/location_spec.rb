require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Location do
  before(:each) do
    @location = Location.new
  end

  describe "associations" do
    it "should have workplaces" do
      @location.should have_many(:workplaces)
    end
  end
end
