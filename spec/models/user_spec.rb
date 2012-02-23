require 'spec_helper'

describe User do

  describe 'having role planner' do
    let(:user) { Factory.build :planner }

    it { user.should be_a_planner }
    it { user.should be_role('planner') }
  end

  describe 'associate with employee' do
    it 'should link the employee to the user on create if employee can be found' do
      employee = Factory :employee
      user = Factory.build :user, employee_id: employee.id

      employee.user.should be_nil
      user.employees.should be_empty

      user.save!

      employee.reload.user.should eql(user)
      user.reload.employees.should include(employee)
    end

    it 'should not link the employee to the user on create if no employee can be found' do
      user = Factory.build :user, employee_id: 'some non existant id'

      user.employees.should be_empty

      user.save!

      user.reload.employees.should be_empty
    end
  end

  describe 'returning the organization of the user' do
    it 'should return the organization where the user is the planner if user is planner for some organization' do
      user = Factory :planner
      organization = Factory :organization, planner: user
      user.organization.should eql(organization)
    end

    it "should return the organization of the user's first employee" do
      user = Factory :user
      organization = Factory :organization
      organization.planner.should be_nil

      employee = Factory :employee, user: user, organization: organization

      user.organization.should eql(organization)
    end

    it "should create a default organization with user as the planner if user is not planner and has no employees" do
      user = Factory :user

      user.roles.should be_empty
      Organization.count.should be(0)

      organization = user.organization

      user.reload.roles.should include('planner')
      Organization.count.should be(1)
      user.organization.should eql(organization)

      # should not create another organization when calling 'organization' on user again
      Organization.count.should be(1)
    end
  end
end
