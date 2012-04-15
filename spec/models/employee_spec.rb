require 'spec_helper'

describe Employee do
  context "full name" do
    it "should be build up by first and last name" do
      employee = Factory.build :employee, :first_name => 'Homer', :last_name => 'Simpson'
      employee.name.should == 'Homer Simpson'
    end

    it "should need a first_name" do
      Factory.build(:employee, :first_name => nil).should be_invalid
      Factory.build(:employee, :first_name => '').should  be_invalid
      Factory.build(:employee, :first_name => ' ').should be_invalid

      Factory.build(:employee, :first_name => 'Homer').should be_valid
    end

    it "should need a last_name" do
      Factory.build(:employee, :last_name => nil).should be_invalid
      Factory.build(:employee, :last_name => '').should  be_invalid
      Factory.build(:employee, :last_name => ' ').should be_invalid

      Factory.build(:employee, :last_name => 'Simpson').should be_valid
    end

    it "should have a value or nil value for weekly_working_time" do
      Factory.build(:employee, :weekly_working_time => -1).should  be_invalid
      Factory.build(:employee, :weekly_working_time => 1.2).should be_valid

      Factory.build(:employee, :weekly_working_time => 0).should   be_valid
      Factory.build(:employee, :weekly_working_time => 40).should  be_valid
      Factory.build(:employee, :weekly_working_time => nil).should be_valid
    end

    context "roles" do
      it { Factory.build(:employee, role: 'planner').should be_valid }
      it { Factory.build(:employee, role: 'owner').should be_valid }
      it { Factory.build(:employee, role: 'planer').should be_invalid }
      it { Factory.build(:employee, role: 'weihnachtsmann').should be_invalid }
    end
  end
end
