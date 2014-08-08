require 'spec_helper'

describe Signup do
  let(:email) { 'me@example.com' }
  let(:signup) do
    described_class.new(
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
    it 'prepares setup' do
      signup.save!
      signup.user.setup.should be_present
    end
  end

  describe '#valid?' do
    it 'accepts correctly looking information' do
      signup.should be_valid
    end
    it 'complains when password does not equal confirmation' do
      signup.password_confirmation = 'something completely different'
      signup.should_not be_valid
      signup.should have(1).error_on(:password_confirmation)
    end
  end
end
