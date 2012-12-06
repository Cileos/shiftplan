require 'spec_helper'

describe Demand do
  it "must have a quantity" do
    build(:demand, quantity: nil).should_not be_valid
  end
end
