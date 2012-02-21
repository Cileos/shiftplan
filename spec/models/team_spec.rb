require 'spec_helper'

describe Team do
  it "should need a name" do
    Factory.build(:team, :name => nil).should be_invalid
    Factory.build(:team, :name => '').should be_invalid
    Factory.build(:team, :name => ' ').should be_invalid
  end
  it "should have a color"
end
