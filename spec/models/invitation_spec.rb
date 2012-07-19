require 'spec_helper'

describe Invitation do
  describe 'associate employee with user' do
    it 'should link the employee to the user on save if user is set' do
      employee = create :employee
      user = create :user
      invitation = create(:invitation, employee: employee, organization: create(:organization))

      employee.user.should be_nil
      user.employees.should be_empty

      invitation.user = user
      invitation.save!

      employee.reload.user.should eql(user)
      user.reload.employees.should include(employee)
    end
  end
end
