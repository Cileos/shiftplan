describe TokenAuthorizedController do
  let(:private_token) { 'affe2342' }
  let(:email) { 'slave@example.com' }
  describe '#current_user' do
    before :each do
      controller.stub params: { private_token: private_token, email: email }
    end

    it 'finds user by email and private token' do
      user = create :confirmed_user, private_token: private_token, email: email
      controller.send(:current_user).should == user
    end

    it 'induces 404 when user could not be found' do
      expect {
        controller.send(:current_user)
      }.to raise_error(TokenAuthorizedController::UserNotFound)
    end
  end
end
