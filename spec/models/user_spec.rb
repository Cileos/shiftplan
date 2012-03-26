require 'spec_helper'

describe User do

  describe 'having role planner' do
    let(:planner) { Factory(:planner, user: Factory(:user)) }

    it { planner.should be_a_planner }
    it { planner.should be_role('planner') }
  end

  describe 'associate with employee' do
    it 'should link the employee to the user on save if employee can be found' do
      employee = Factory :employee
      employee_2 = Factory :employee
      user = Factory.build :user, employee_id: employee.id

      employee.user.should be_nil
      user.employees.should be_empty

      # test associate on create
      user.save!

      employee.reload.user.should eql(user)
      user.reload.employees.should include(employee)

      # test associate on save
      user.employee_id = employee_2.id
      user.save!

      employee_2.reload.user.should eql(user)
      user.reload.employees.should include(employee)
      user.reload.employees.should include(employee_2)
    end

    it 'should not link the employee to the user on save if no employee can be found' do
      user = Factory.build :user, employee_id: 'some non existant id'

      user.employees.should be_empty

      user.save!

      user.reload.employees.should be_empty
    end
  end
end
