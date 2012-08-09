require 'spec_helper'

describe User do

  describe 'having role planner' do
    let(:planner) { create(:employee_planner, user: create(:user)) }

    it { planner.should be_a_planner }
    it { planner.should be_role('planner') }
  end

  context "current_employee" do
    let(:user) { create :user }
    let(:employee) { create(:employee, user: user) }

    it "should accept nil" do
      expect { user.current_employee = nil }.not_to raise_error
      user.current_employee.should be_nil
    end

    it "should accept employee who's user is self" do
      expect { user.current_employee = employee }.not_to raise_error
      user.current_employee.should == employee
    end

    let(:foreign_employee) { create(:employee) }
    it "should not accept employee who's user is someone else" do
      expect { user.current_employee = foreign_employee }.to raise_error
    end
  end
end
