describe TokenAuthorizedController do
  let(:private_token) { 'affe2342' }
  let(:email) { 'slave@example.com' }
  describe '#current_user' do
    it 'finds user by email and private token' do
      controller.stub params: { private_token: private_token, email: email }
      user = create :confirmed_user, private_token: private_token, email: email
      controller.send(:current_user).should == user
    end
  end
end
