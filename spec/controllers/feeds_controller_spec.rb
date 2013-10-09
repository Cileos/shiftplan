
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
        build_stubbed(:scheduling, attrs.reverse_merge(updated_at: Time.zone.now) )
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


    it 'sets UID for the event to be identified' do
      stub_schedulings id: 23
      fetch
      event.uid.should_not be_blank
    end

    it 'sets LAST-MODIFIED for unknown reasons' do
      time = Time.zone.parse('2013-05-05 07:23')
      stub_schedulings updated_at: time
      fetch
      event.last_modified.should == time
    end

    it 'sets SEQUENCE for external programs to detect updates' do
      # RFC 5455 says:
      # "When a calendar component is created, its sequence number is zero
      # [..]. It is monotonically incremented [..] each time the "Organizer"
      # makes a significant revision to the calendar component."
      #
      # It does not say by how much. As time is monotonically increasing, we
      # just use the seconds since epoch as a sequence
      time = Time.zone.parse('2013-05-05 07:23')
      stub_schedulings updated_at: time
      fetch
      event.sequence.should == time.to_i
    end
  end
end
