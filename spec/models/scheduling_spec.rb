require 'spec_helper'

describe Scheduling do

  context "hour accessor" do
    let(:scheduling) { Scheduling.new(date: Date.today) }

    context "for start" do
      it "accepts normal numbers" do
        scheduling.start_hour = 8
        scheduling.start_hour.should == 8
      end

      it "accepts zero as startof day" do
        scheduling.start_hour = 0
        scheduling.start_hour.should == 0
      end
    end
  end

  context "normal time range" do
    # must define "today" here to travel before building anything
    before(:each) { Timecop.travel Time.parse('1988-02-03 23:42') }
    after(:each)  { Timecop.return }

    let(:starts_at)      { '1988-05-05 09:00' }
    let(:ends_at)        { '1988-05-05 17:00' }
    let(:the_date)       { '1988-05-05' }
    let(:starts_at_date) { Time.zone.parse(starts_at) }
    let(:ends_at_date)   { Time.zone.parse(ends_at) }
    before(:each)        { scheduling.valid? }


    shared_examples "completely defined" do
      it do
        scheduling.should be_valid
      end

      it "has start time set" do
        scheduling.starts_at.should == starts_at_date
      end

      it "has end time set" do
        scheduling.ends_at.should == ends_at_date
      end

      it "has week set" do
        scheduling.week.should == 18
      end

      it "has cwday set" do
        scheduling.cwday.should == 4 # thursday
      end

      it "has year set" do
        scheduling.year.should == 1988
      end

      it "has date set" do
        scheduling.date.should == starts_at_date.to_date
      end

      it "calculates length" do
        scheduling.length_in_hours.should == 8
      end

      it "regenerates quickie" do
        scheduling.quickie.should == '9-17'
      end

      context "saved and reloaded" do
        let(:reloaded) do
          scheduling.save!
          Scheduling.find scheduling.id
        end

        it "has week saved" do
          scheduling.read_attribute(:week).should == 18
        end

        it "has year saved" do
          scheduling.read_attribute(:year).should == 1988
        end
      end
    end

    # use factory except for the time range related attributes, so the
    # validity of the Scheduling is not compromised
    def build(attrs={})
      Factory.build :scheduling, attrs.reverse_merge({
        starts_at: nil,
        ends_at:   nil,
        week:      nil,
        year:      nil,
        date:      nil
      })
    end

    describe "explictly given" do
      it_behaves_like 'completely defined' do
        let :scheduling do
          build({
            starts_at: starts_at,
            ends_at:   ends_at
          })
        end
      end
    end

    describe "given as week, cwday and quicky (current year implied)" do
      it_behaves_like 'completely defined' do
        let :scheduling do
          build({
            week:       18,
            cwday:      4,
            quickie:    '9-17'
          })
        end
      end

    end

    describe "given as date and hours" do
      it_behaves_like 'completely defined' do
        let :scheduling do
          build({
            date:       the_date,
            start_hour: 9,
            end_hour:   17
          })
        end
      end
    end

    describe "given as date and quickie" do
      it_behaves_like 'completely defined' do
        let :scheduling do
          build({
            date:      the_date,
            quickie:   '9-17'
          })
        end
      end
    end

    describe "old scheduling without week or year, synced" do
      it_behaves_like 'completely defined' do
        let :scheduling do
          s = build({
            date:      the_date,
            quickie:   '9-17'
          })
          s.save!
          Scheduling.update_all({week: nil, year: nil}, {id: s.id})
          Scheduling.sync!
          s
        end
      end
    end

    describe "only start hour given as quickie" do
      shared_examples "having invalid quickie" do
        it { scheduling.should_not be_valid }

        it "has an error on quickie" do
          scheduling.valid?
          scheduling.should have_at_least(1).errors_on(:quickie)
        end
      end
      context "on creation" do
        let :scheduling do
          build({
            date:      the_date,
            quickie:   '9-'
          })
        end
        it_behaves_like 'having invalid quickie'
      end
      context "on update" do
        let :scheduling do
          Factory(:scheduling).tap do |s|
            s.quickie = '9-'
          end
        end

        it_behaves_like 'having invalid quickie'
      end
    end
  end

  describe "ranging over midnight" do
    let(:nightwatch) { Factory.build :scheduling, quickie: '19-6' }

    it "should have hours set" do
      nightwatch.valid?
      nightwatch.start_hour.should == 19
      nightwatch.end_hour.should == 24
    end

    it "should split the length in hours correctly" do
      nightwatch.save!
      nightwatch.length_in_hours.should == 5
      nightwatch.next_day.length_in_hours.should == 6
    end

    it "should create 2 scheduling, ripped apart at midnight" do
      expect { nightwatch.save! }.to change(Scheduling, :count).by(2)
    end
  end

  context "team" do
    let(:team)        { Factory :team, :name => 'The A Team' }
    let(:plan)        { Factory :plan, :organization => team.organization }
    let(:scheduling) do
      Factory.build :scheduling,
        :start_hour   => 1,
        :end_hour     => 23,
        :plan         => plan
    end

    it "can be assigned through quickie" do
      scheduling.quickie = '1-23 The A Team'
      scheduling.valid?
      scheduling.team.should == team
      scheduling.team_name.should == team.name
    end

    context 'assignment by name' do

      it "can be assigned by name" do
        scheduling.team_name = team.name
        scheduling.team.should == team
        scheduling.team_name.should == team.name
      end

      it "build team if none exists yet" do
        scheduling.team_name = 'The B Team'
        scheduling.team.should_not be_nil
        scheduling.team.should_not be_persisted
      end

      it "applies wanted shortcut to fresh team" do
        scheduling.team_name = 'The B Team'
        scheduling.team_shortcut = 'B'
        scheduling.team.should_not be_nil
        scheduling.team.should_not be_persisted
        scheduling.team.shortcut.should == 'B'
      end

      it "ignores given shortcut when team already exists" do
        scheduling.team_name = team.name
        scheduling.team_shortcut = 'B'
        scheduling.team.shortcut.should_not == 'B'
      end

      it "may not use teams from other organizations, instead build its own" do
        other_team = Factory :team, :name => 'The Bad Guys'
        scheduling.team_name = other_team.name
        scheduling.team.should be_present
        scheduling.team.should_not == other_team
        scheduling.team.organization.should == team.organization
      end

      it "should be included in the quickie" do
        scheduling.team = team
        scheduling.team.stub(:to_quickie).and_return('<team quickie part>')
        scheduling.quickie.should == '1-23 <team quickie part>'
      end

    end
  end

  describe 'quickie completion' do
    let(:plan) { Factory :plan }
    before do
      Factory :scheduling, date: '2011-11-01', plan: plan, quickie: '9-17 Schuften'
      Factory :scheduling, date: '2011-11-02', plan: plan, quickie: '9-17 Schuften'
      Factory :scheduling, date: '2011-11-02', plan: plan, quickie: '11-19 Schuften'
      Factory :scheduling, date: '2011-11-02', plan: plan, quickie: '20-23 Glotzen'
    end

    let(:completions) { plan.schedulings.quickies }

    it "should contain all quickies being of unique time range and team" do
      completions.should include('9-17 Schuften [S]')
      completions.should include('11-19 Schuften [S]')
      completions.should include('20-23 Glotzen [G]')
    end

    it "should not include doubles" do
      completions.should have(3).records
    end
  end
end
