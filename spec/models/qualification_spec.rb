require 'spec_helper'

describe Qualification do
  it "must have a name" do
    build(:qualification, name: nil).should_not be_valid
    build(:qualification, name: '' ).should_not be_valid
  end
  it "must have an organization" do
    build(:qualification, organization: nil).should_not be_valid
  end
end
