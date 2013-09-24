
describe FeedsController do
  describe '#upcoming' do
    render_views
    let(:user) { double('User').as_null_object }
    before :each do
      controller.stub current_user: user
      user.stub_chain(:schedulings, :upcoming).and_return([
        build_stubbed(:scheduling, starts_at: 1.day.from_now, ends_at: 1.day.from_now + 1.hour)
      ])
    end

    it 'outputs upcoming schedulings as .ics' do
      get :upcoming, format: 'ics', email: 'needed', private_token: 'security'
      response.should be_success
      response.body.should start_with('BEGIN:VCALENDAR')
    end

  end
end
