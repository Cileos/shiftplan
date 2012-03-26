require 'spec_helper'

describe Organization do
  it "should need a name" do
    Factory.build(:organization, :name => nil).should be_invalid
  end
end
