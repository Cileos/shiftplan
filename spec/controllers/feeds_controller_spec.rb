
describe FeedsController do
  let(:token) { 'affe2342' }
  let(:email) { 'slave@example.com' }
  describe '#current_user' do
    xit 'finds user by email and private token' do
      user = create :confirmed_user, private_token: token, email: email
      get :upcoming, token: token, email: email
      assigns[:current_user].should == user
    end

  end
  describe '#upcoming' do
    render_views
    let(:user) { double('User').as_null_object }
    before :each do
      controller.stub current_user: user
      user.stub_chain(:schedulings, :upcoming).and_return([
        build_stubbed(:scheduling, starts_at: 1.day.from_now, ends_at: 1.day.from_now + 1.hour)
      ])
    end

    it 'it outputs upcoming schedulings as .ics' do
      get :upcoming, token: token, email: email, format: 'ics'
      response.should be_success
      response.body.should start_with('BEGIN:VCALENDAR')
    end

  end
end
