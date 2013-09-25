
describe FeedsController do
  describe '#upcoming' do
    def fetch
      get :upcoming, format: 'ics', email: 'needed', private_token: 'f' * 20
    end
    render_views
    let(:user) { double('User').as_null_object }
    before :each do
      controller.stub current_user: user
    end

    it 'outputs upcoming schedulings as .ics' do
      fetch
      response.should be_success
      response.body.should start_with('BEGIN:VCALENDAR')
    end

    # parse again
    let(:parsed) { RiCal.parse_string(response.body).first }
    let(:events) { parsed.events }
    let(:event) { events.first }

    let(:team) { build_stubbed :team, name: 'The A Team' }
    let(:plan) { build_stubbed :plan, name: 'Hero Work' }

    def stub_schedulings(*attrss)
      build = attrss.map do |attrs|
        build_stubbed(:scheduling, attrs)
      end

      user.stub_chain(:schedulings, :upcoming).and_return(build)
    end

    it 'defines start time' do
      time = Time.zone.parse('2013-05-05 05:23')
      stub_schedulings starts_at: time
      fetch
      event.dtstart.should == time
    end

    it 'defines end time' do
      time = Time.zone.parse('2013-05-05 07:23')
      stub_schedulings ends_at: time
      fetch
      event.dtend.should == time
    end

    it 'mentiones lonely team name' do
      stub_schedulings team: team, plan: nil
      fetch
      event.summary.should == 'The A Team'
    end


    it 'mentions lonely plan name' do
      stub_schedulings plan: plan, team: nil
      fetch
      event.summary.should == 'Hero Work'
    end

    it 'mentions team name (plan name)' do
      stub_schedulings plan: plan, team: team
      fetch
      event.summary.should == 'The A Team (Hero Work)'
    end

    it 'defines calendar name' do
      fetch
      parsed.x_wr_calname.first.should =~ /Clockwork/
    end

    it 'shows intent to publish the events' do
      fetch
      # OPTIMIZE ri_cal does not add ':' delimiter on generation, and recognizes it on parsing
      parsed.method_property.to_s.should == ':PUBLISH'
      response.body.should include('METHOD:PUBLISH')
    end

  end
end
