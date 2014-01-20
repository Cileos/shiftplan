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
    it 'creates user' do
      expect { signup.save! }.to change { User.count }.from(0).to(1)
    end

    it 'creates an account' do
      expect { signup.save! }.to change { Account.count }.from(0).to(1)
    end

    it 'creates an organization' do
      expect { signup.save! }.to change { Organization.count }.from(0).to(1)
    end

    it 'creates an employee' do
      expect { signup.save! }.to change { Employee.count }.from(0).to(1)
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
