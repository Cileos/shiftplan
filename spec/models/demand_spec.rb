require 'spec_helper'

describe Demand do
  it "must have a quantity" do
    build(:demand, quantity: nil).should_not be_valid
  end
  it "must have a quanity > 0" do
    build(:demand, quantity: 0).should_not be_valid
    build(:demand, quantity: -1).should_not be_valid
  end
end
