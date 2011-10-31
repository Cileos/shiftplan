require 'spec_helper'

describe Employee do
  context "full name" do
    it "should be build up by first and last name" do
      employee = Factory.build :employee, :first_name => 'Homer', :last_name => 'Simpson'
      employee.full_name.should == 'Homer Simpson'
    end
  end
end
