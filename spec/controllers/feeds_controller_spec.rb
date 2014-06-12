
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

    context 'start_time' do
      subject { fetch && event.dtstart }

      it 'is set' do
        time = Time.zone.parse('2013-05-05 05:23')
        stub_schedulings starts_at: time
        should == time
      end
    end

    context 'end_time' do
      subject { fetch && event.dtend }

      it 'is defined' do
        time = Time.zone.parse('2013-05-05 07:23')
        stub_schedulings ends_at: time
        should == time
      end
    end

    context 'summary' do
      subject { fetch && event.summary }

      it 'mentiones lonely team name' do
        stub_schedulings team: team, plan: nil
        should == 'The A Team'
      end


      it 'mentions lonely plan name' do
        stub_schedulings plan: plan, team: nil
        should == 'Hero Work'
      end

      it 'mentions team name (plan name)' do
        stub_schedulings plan: plan, team: team
        should == 'The A Team (Hero Work)'
      end
    end

    context 'META' do
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

    context 'UID' do
      subject { fetch && event.uid }

      it 'is set for the event to be identified' do
        stub_schedulings id: 23
        should_not be_blank
      end
    end

    context 'last_modified' do
      subject { fetch && event.last_modified }

      it 'sets LAST-MODIFIED for unknown reasons' do
        time = Time.zone.parse('2013-05-05 07:23')
        stub_schedulings updated_at: time
        should == time
      end
    end

    context 'sequence' do
      subject { fetch && event.sequence }

      it 'is set for external programs to detect updates' do
        # RFC 5455 says:
        # "When a calendar component is created, its sequence number is zero
        # [..]. It is monotonically incremented [..] each time the "Organizer"
        # makes a significant revision to the calendar component."
        #
        # It does not say by how much. As time is monotonically increasing, we
        # just use the seconds since epoch as a sequence
        time = Time.zone.parse('2013-05-05 07:23')
        stub_schedulings updated_at: time
        should == time.to_i
      end
    end

  end
end
