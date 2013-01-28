require 'spec_helper'

describe Demand do
  it "must have a quantity" do
    build(:demand, quantity: nil).should_not be_valid
  end
  it "destroys all its demands shifts when destroyed" do
    demand = create(:demand)
    demand.shifts << create(:shift)
    demand.shifts << create(:shift)

    lambda {
      demand.destroy
    }.should change(DemandsShifts, :count).from(2).to(0)
  end
end
