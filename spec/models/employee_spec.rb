require 'spec_helper'

describe Employee do
  context "full name" do
    it "should be build up by first and last name" do
      employee = build :employee, :first_name => 'Homer', :last_name => 'Simpson'
      employee.name.should == 'Homer Simpson'
    end

    it "should need a first_name" do
      build(:employee, :first_name => nil).should be_invalid
      build(:employee, :first_name => '').should  be_invalid
      build(:employee, :first_name => ' ').should be_invalid

      build(:employee, :first_name => 'Homer').should be_valid
    end

    it "should need a last_name" do
      build(:employee, :last_name => nil).should be_invalid
      build(:employee, :last_name => '').should  be_invalid
      build(:employee, :last_name => ' ').should be_invalid

      build(:employee, :last_name => 'Simpson').should be_valid
    end

    it "should have a value or nil value for weekly_working_time" do
      build(:employee, :weekly_working_time => -1).should  be_invalid
      build(:employee, :weekly_working_time => 1.2).should be_valid

      build(:employee, :weekly_working_time => 0).should   be_valid
      build(:employee, :weekly_working_time => 40).should  be_valid
      build(:employee, :weekly_working_time => nil).should be_valid
    end

    context "roles" do
      it { build(:employee, role: 'planner').should be_valid }
      it { build(:employee, role: 'owner').should be_valid }
      it { build(:employee, role: 'planer').should be_invalid }
      it { build(:employee, role: 'weihnachtsmann').should be_invalid }
      it { create(:employee, role: 'planner').reload.role.should == 'planner' }
    end
  end

  context "WAZ in form" do
    it "is an integer for the time being" do
      create(:employee, weekly_working_time: 23.5).weekly_working_time_before_type_cast.should == 23
    end

    it "keeps beeing empty (no accidental 0)" do
      create(:employee, weekly_working_time: nil).weekly_working_time_before_type_cast.should be_nil
    end
  end
end
