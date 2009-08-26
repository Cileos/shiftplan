require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Workplace do
  before(:each) do
    @workplace = Workplace.new
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

  describe "instance methods" do
    describe "#color" do
      it "should always show hexadecimal color prefixed with a hash sign" do
        @workplace.color = '#AABBCC'
        @workplace.color.should == '#AABBCC'

        @workplace.color = 'AABBCC'
        @workplace.color.should == '#AABBCC'

        # @workplace.color = '#ABC'
        # @workplace.color.should == '#ABC'
        # 
        # @workplace.color = 'ABC'
        # @workplace.color.should == '#ABC'
      end
    end

    describe "#color=" do
      it "should always remove prefixed hash sign from hexadecimal color" do
        @workplace.color = 'AABBCC'
        @workplace.attributes['color'].should == 'AABBCC'

        @workplace.color = '#AABBCC'
        @workplace.attributes['color'].should == 'AABBCC'

        # @workplace.color = 'ABC'
        # @workplace.attributes['color'].should == 'ABC'
        # 
        # @workplace.color = '#ABC'
        # @workplace.attributes['color'].should == 'ABC'
      end
    end
  end
end
