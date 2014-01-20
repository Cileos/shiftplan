require 'spec_helper'

describe Signup do
  let(:email) { 'me@example.com' }
  let(:signup) do
    described_class.new(
      email: email
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
  end

  describe '#valid?' do
    it 'complains when password does not equal confirmation'
  end
end
