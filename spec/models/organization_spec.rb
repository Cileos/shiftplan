require 'spec_helper'

describe Organization do
  let(:planer) { Factory :planer }

  it "should not need a name as long it is the only organization of a planer" do
    organization = Factory.build :organization, :name => nil, :planer => planer
    organization.should be_valid
  end
end
