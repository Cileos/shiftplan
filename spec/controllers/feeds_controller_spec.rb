
describe FeedsController do
  describe '#upcoming' do
    let(:token) { 'affe2342' }
    let(:email) { 'slave@example.com' }
    it 'finds user by email and private token' do
      user = create :confirmed_user, private_token: token, email: email
      get :upcoming, token: token, email: email
      assigns[:current_user].should == user
    end

  end
end
