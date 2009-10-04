require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe JsonHelper do
  describe "#object" do
    before(:each) do
      helper.instance_variable_set(:@foo, 'bar')
      helper.instance_variable_set(:@object_name, 'foo')
    end

    it "should return the object referenced by @object_name" do
      helper.object.should == 'bar'
    end
  end

  describe "#json_errors_for" do
    before(:each) do
      @object = User.new
      @object.valid?
    end

    it "should return a given object's errors formatted as JSON" do
      # FIXME: make less brittle in terms of whitespace
      expected = "'user': { 'password': ['can\\'t be blank'],\n'email': ['can\\'t be blank',\n'is invalid'] }"

      helper.json_errors_for(@object).should == expected
    end
  end
end