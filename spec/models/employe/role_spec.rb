require 'spec_helper'

describe Employee, 'role' do
  shared_examples 'a role protected by mass-assignment' do
    it "cannot be mass-assigned to 'owner' as nobody" do
      expect { employee.assign_attributes({ role: 'owner'}) }.
        not_to change(employee, :role)
    end

    it "cannot be mass-assigned to 'planner' as nobody" do
      expect { employee.assign_attributes({ role: 'owner'}) }.
        not_to change(employee, :role)
    end

    it "cannot be mass-assigned to 'owner' as a planner" do
      expect { employee.assign_attributes({ role: 'owner'}, {as: 'planner'}) }.
        not_to change(employee, :role)
    end

    it "can be mass-assigned to 'planner' as a planner" do
      expect { employee.assign_attributes({ role: 'planner'}, {as: 'planner'}) }.
        to change(employee, :role).to('planner')
    end

    it "can be mass-assigned to 'planner' as an owner" do
      expect { employee.assign_attributes({ role: 'planner'}, {as: 'owner'}) }.
        to change(employee, :role).to('planner')
    end

    it "cannot be mass-assigned to 'owner' as a owner" do
      expect { employee.assign_attributes({ role: 'owner'}, {as: 'owner'}) }.
        not_to change(employee, :role)
    end
  end

  context "of new employee" do
    let(:employee) { build(:employee, role: nil) }
    it_behaves_like 'a role protected by mass-assignment'
  end

  context "of persisted employee" do
    let(:employee) { build(:employee, role: nil) }
    before :each do
      employee.stub(:persisted? => true)
    end
    it_behaves_like 'a role protected by mass-assignment'
  end

  context "accepted values" do
    it "include 'planner'" do
      build(:employee, role: 'planner').should be_valid
    end
    it "include 'owner'" do
      build(:employee, role: 'owner').should be_valid
    end
    it "exclude 'planer'" do
      build(:employee, role: 'planer').should be_invalid
    end
    it "exclude 'weihnachtsmann'" do
      build(:employee, role: 'weihnachtsmann').should be_invalid
    end
    it "is persisted" do
      create(:employee, role: 'planner').reload.role.should == 'planner'
    end
  end
end
