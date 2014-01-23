require 'spec_helper'

describe Signup do
  let(:email) { 'me@example.com' }
  let(:signup) do
    described_class.new(
      first_name: 'Monty',
      last_name: 'Burns',
      account_name: 'Monty Enterprises',
      organization_name: 'Power Plant',
      email: email,
      password: 'secret',
      password_confirmation: 'secret'
    )
  end

  describe '#user' do
    it 'is a User' do
      signup.user.should be_a(User)
    end

    it 'has given email assigned' do
      signup.user.email.should == email
    end
  end

  describe '#save!' do
    describe 'after' do
      before :each do
        signup.save!
      end
      let(:account) { Account.first }
      let(:organization) { Organization.first }
      let(:employee) { Employee.first }

      describe 'the created acount' do
        it 'has the employee as owner' do
          account.owner.should == employee
        end
      end

      describe 'the created employee' do
        it 'belongs to the account (regardless of being owner)' do
          employee.account.should == account
        end

        it 'belongs to the user signing up' do
          signup.user.employees.should include(employee)
        end

        it 'is member in the organization' do
          employee.should have(1).memberships
          employee.memberships.first.organization.should == organization
        end
      end
    end
  end

  describe '#valid?' do
    it 'accepts correctly looking information' do
      signup.should be_valid
    end
    it 'complains when password does not equal confirmation' do
      signup.password_confirmation = 'something completely different'
      signup.should_not be_valid
      signup.should have(1).error_on(:password)
    end
  end
end
