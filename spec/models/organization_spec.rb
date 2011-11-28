require 'spec_helper'

describe Organization do
  let(:planner) { Factory :planner }

  it "should not need a name as long it is the only organization of a planner" do
    organization = Factory.build :organization, :name => nil, :planner => planner
    organization.should be_valid
  end
end
