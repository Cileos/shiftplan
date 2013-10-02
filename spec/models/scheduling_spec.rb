# encoding: utf-8

require 'spec_helper'

describe Scheduling do

  in_locale :de

  context "with illegal characters in team name (quickie)" do
    let(:scheduling) { Scheduling.new quickie: "9-17 work 'hard'" }
    it { scheduling.should_not be_valid }

    it "should not have errors on start time" do
      scheduling.valid?
      scheduling.should have(:no).errors_on(:starts_at)
    end

    it "should not have errors on end time" do
      scheduling.valid?
      scheduling.should have(:no).errors_on(:ends_at)
    end
  end

  context "without start date and quickie" do
    let(:scheduling) { build :scheduling, starts_at: nil, ends_at: nil, quickie: '', week: nil, year: nil }
    it { scheduling.should_not be_valid }
    it { scheduling.should have_at_least(1).errors_on(:quickie) }
  end

  context "hour" do
    let(:scheduling) { Scheduling.new(date: Date.today) }

    it "is part of TimeRangeComponentsAccessible" do
      scheduling.should_receive(:compose_time_range_from_components)
      scheduling.valid?
    end

    context "for start" do
      it "accepts normal numbers" do
        scheduling.start_hour = 8
        scheduling.valid?
        scheduling.start_hour.should == 8
      end

      it "accepts zero as start of day" do
        scheduling.start_hour = 0
        scheduling.valid?
        scheduling.start_hour.should == 0
      end
    end

    context "for end" do
      it "accepts normal numbers" do
        scheduling.end_hour = 17
        scheduling.valid?
        scheduling.end_hour.should == 17
      end

      it "accepts 0 as end of day" do
        scheduling.end_hour = 0
        scheduling.valid?
        scheduling.end_hour.should == 24
      end

      it "accepts 24 as end of day" do
        scheduling.end_hour = 24
        scheduling.valid?
        scheduling.end_hour.should == 24
      end


    end
  end

  context  'from 0 to 0' do
    let(:the_date)       { '1988-05-05' }
    let(:scheduling) { build_without_dates(date: the_date, start_hour: 0, end_hour: 0)}

    it 'is valid' do
      scheduling.should be_valid
    end

    it 'is 24 hour long' do
      scheduling.valid?
      scheduling.length_in_hours.should == 24
    end
  end

  context 'from 1 to 1' do
    let(:scheduling) { build :scheduling_by_quickie, quickie: '1-1' }
    it 'is invalid' do
      scheduling.should_not be_valid
    end
  end

  context "normal time range" do
    # must define "today" here to travel before building anything
    before(:each) { Timecop.travel Time.parse('1988-02-03 23:42') }

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

    end

    describe "explictly given" do
      it_behaves_like 'completely defined' do
        let :scheduling do
          build_without_dates({
            starts_at: starts_at,
            ends_at:   ends_at
          })
        end
      end
    end

    describe "given as week, cwday and quicky (current year implied)" do
      it_behaves_like 'completely defined' do
        let :scheduling do
          build_without_dates({
            week:       18,
            cwday:      4,
            quickie:    '9-17'
          })
        end
      end
    end

    describe 'given as date and times' do
      it_behaves_like 'completely defined' do
        let :scheduling do
          build_without_dates({
            date: starts_at_date,
            start_time: '09:00',
            end_time: '17:00'
          })
        end
      end
    end

    describe "given as date only" do
      let :scheduling do
        build_without_dates( date: the_date)
      end
      it "should accept date to fill selectbox" do
        scheduling.date.should == Time.zone.parse(the_date).to_date
      end
    end

    describe "given as date and hours" do
      it_behaves_like 'completely defined' do
        let :scheduling do
          build_without_dates({
            date:       the_date,
            start_hour: 9,
            end_hour:   17
          })
        end
      end
    end

    describe "given as hours and date" do
      it_behaves_like 'completely defined' do
        let :scheduling do
          build_without_dates({
            start_hour: 9,
            end_hour:   17,
            date:       the_date
          })
        end
      end
    end

    describe "given as date and quickie" do
      it_behaves_like 'completely defined' do
        let :scheduling do
          build_without_dates({
            date:      the_date,
            quickie:   '9-17'
          })
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
          build_without_dates({
            date:      the_date,
            quickie:   '9-'
          })
        end
        it_behaves_like 'having invalid quickie'
      end
      context "on update" do
        let :scheduling do
          create(:scheduling).tap do |s|
            s.quickie = '9-'
          end
        end

        it_behaves_like 'having invalid quickie'
      end
    end
  end

  describe "ranging over midnight" do
    let(:nightwatch) { build :scheduling, quickie: '19-6', date: Date.today }

    it "should have hours set" do
      nightwatch.valid?
      nightwatch.start_hour.should == 19
      nightwatch.end_hour.should == 24
    end

    # reload to force AR to re-init the dates and really delete all our state
    let(:first) { nightwatch.class.find(nightwatch.id) }
    let(:second) { nightwatch.class.find(nightwatch.next_day_id) }

    context "pairing_id" do
      before(:each) { nightwatch.save! }

      it "should equal id for the first part" do
        nightwatch.pairing_id.should == nightwatch.id
      end

      it "should equal the id of the first part for the second part" do
        nightwatch.next_day.pairing_id.should == nightwatch.id
      end
    end

    context "splitting the length in hours" do
      before(:each) { nightwatch.save! }

      it "should hold hours until midnight" do
        first.length_in_hours.should == 5  # is ~ 4.99999999903 without reloading the record
      end

      it "should move rest of the length to the next day" do
        second.length_in_hours.should == 6
      end

      it "has next day assiciated" do
        second.should == nightwatch.next_day
      end
    end


    it "should create 2 scheduling, ripped apart at midnight" do
      expect { nightwatch.save! }.to change(Scheduling, :count).by(2)
    end

    context "with year and week turn" do
      # in ISO 8601, the week with january 4th is the first calendar week
      # in 2012, the January 1st is a sunday, so January 1st is in week 52 (of year 2011)
      let!(:nightwatch) { build_without_dates(quickie: '19-6', date: '2012-01-01').tap(&:save!) }

      context "the day of the night watch" do
        subject { nightwatch }

        it { subject.year.should == 2012 }
        it { subject.cwyear.should == 2011 }
        it { subject.week.should == 52 }
        it { subject.next_day.should_not be_blank }
      end

      context "the next day" do
        subject { nightwatch.next_day }

        it { should be_persisted }
        it { should be_valid }
        it "should keep employee assigned" do
          subject.employee.should == nightwatch.employee
        end
        it "should keep plan assigned" do
          subject.plan.should == nightwatch.plan
        end
        it "should keep team assigned" do
          subject.team.should == nightwatch.team
        end
        it { subject.year.should == 2012 }
        it { subject.cwyear.should == 2012 }
        it { subject.week.should == 1 }
        it { subject.previous_day.should == nightwatch }
      end
    end
  end

  context "with time specified in 15-minute intervals" do
    let(:sch) { build(:scheduling_by_quickie, quickie: '11:15-13:45')}

    it "does not round #length_in_hours" do
      sch.length_in_hours.should == 2.5
    end
  end


  # TimeRangeComponentsAccessible
  context 'fractal hour after midnight ( 0-0:15 )' do
    let(:sch) { build(:scheduling_by_quickie, quickie: '0-0:15') }
    it 'starts at midnight' do
      sch.start_hour.should == 0
      sch.start_minute.should == 0
    end

    it 'ends 15 minutes after midnight' do
      sch.end_hour.should == 0
      sch.end_minute.should == 15
    end

    it 'lasts only a quarter of an hour' do
      sch.length_in_hours.should == 0.25
    end

    it 'has period reflecting it' do
      sch.period.should == '0-00:15'
    end
  end

  context "team" do
    let(:team)        { create :team, :name => 'The A Team' }
    let(:plan)        { create :plan, :organization => team.organization }
    let(:scheduling) do
      build :scheduling,
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
        other_team = create :team, :name => 'The Bad Guys'
        scheduling.team_name = other_team.name
        scheduling.team.should be_present
        scheduling.team.should_not == other_team
        scheduling.team.organization.should == team.organization
      end

      it "is included in the quickie" do
        scheduling.team = team
        scheduling.team.stub(:to_quickie).and_return('<team quickie part>')
        scheduling.quickie.should =~ /<team quickie part>$/
      end

      context "with team" do
        it "should not clear association if assigned quickie does not contain (same) team name"
      end

    end
  end

  describe 'quickie completion' do
    let(:plan) { create :plan }
    before do
      create :scheduling, date: '2011-11-01', plan: plan, quickie: '9-17 Schuften'
      create :scheduling, date: '2011-11-02', plan: plan, quickie: '9-17 Schuften'
      create :scheduling, date: '2011-11-02', plan: plan, quickie: '11-19 Schuften'
      create :scheduling, date: '2011-11-02', plan: plan, quickie: '20-23 Glotzen'
      create :scheduling, date: '2011-11-02', plan: plan, quickie: '8:15-20:45 Glotzen'
      create :scheduling, date: '2011-11-02', quickie: '11-12 Managen'
    end

    let(:completions) { plan.schedulings.quickies }

    it "should contain all quickies being of unique time range and team" do
      completions.should include('9-17 Schuften [S]')
      completions.should include('11-19 Schuften [S]')
      completions.should include('20-23 Glotzen [G]')
      completions.should include('08:15-20:45 Glotzen [G]')
      completions.should_not include('11-12 Managen [M]')
    end

    it "should not include doubles" do
      completions.should have(4).records
    end
  end

  describe "overlapping" do
    it "does happen with at least one common hour" do
      one = create :scheduling, quickie: '9-12'
      two = create :scheduling, quickie: '11-17'
      one.should be_overlap(two)
      two.should be_overlap(one)
    end
    it "does not happen without common hours" do
      one = create :scheduling, quickie: '9-11'
      two = create :scheduling, quickie: '11-17'
      one.should_not be_overlap(two)
      two.should_not be_overlap(one)
    end
    it "does not happen on different stacks" do
      one = create :scheduling, quickie: '9-17', stack: 0
      two = create :scheduling, quickie: '9-17', stack: 1
      one.should_not be_overlap(two)
      two.should_not be_overlap(one)
    end
  end

  context "with a deeply nested comments" do
    let(:scheduling) { create :scheduling }
    let(:employee)   { create :employee } # just talking to himself

    def create_comment(attrs={})
      Comment.build_from(scheduling, employee, attrs).tap(&:save!)
    end
    before do
      c1   = create_comment body: "One"
      c2   = create_comment body: "Two"
      c21  = create_comment body: "Two-one", parent: c2
      c211 = create_comment body: "Two-one-one", parent: c21
      c3   = create_comment body: "Three"
    end
    # acts_as_commentable_with_threading 1.1.2 (pure) tries to fetch comments which are already deleted. Almost minimal version:
    # comment
    # comment
    #   answer
    #     superanswer
    # comment
    it "destroys all comments when destroyed" do
      s = Scheduling.find scheduling.id
      expect do
        s.destroy
      end.to change { Comment.count }.from(5).to(0)
    end
  end

  context "undoing changes" do
    let(:team)     { create :team, name: 'Original' }
    let(:plan)     { create :plan, organization: team.organization }
    let(:record)   { create :scheduling, quickie: "1-15", team: team, plan: plan }
    let(:new_team) { create :team, name: 'New', organization: record.team.organization }
    let(:actual_updates)  { { team_id: new_team.id } }
    let(:updates)  { { quickie: "1-18 #{new_team.to_quickie}" } }
    let(:undone)   { record.with_previous_changes_undone }

    before :each do
      record.update_attributes!(updates)
    end

    it "should have accepted the changes" do
      record.starts_at.hour.should == 1
      record.ends_at.hour.should == 18
    end

    it "should have hash to work on" do
      record.attributes_for_undo.should be_a(Hash)
      record.attributes_for_undo.should be_hash_matching({'team_id'=> team.id}, ignore_additional: true)
      record.attributes_for_undo.should_not have_key('starts_at')
      record.attributes_for_undo.should have_key('ends_at')
    end

    it "should be present" do
      undone.should be_present
      undone.should be_a(Scheduling)
    end

    it "should revert to the old values" do
      undone.team.should == team
    end

    it "should accept new team" do
      record.team.should == new_team
    end

    it "should not touch the original record iself" do
      undone
      record.team.should == new_team
    end
  end

  context ".upcoming" do
    it "is a working scope" do
      expect { Scheduling.upcoming }.to_not raise_error
    end
  end

  context ".starting_in_the_next" do
    context "with a valid interval argument" do
      it "does not raise an argument error" do
        expect { Scheduling.starting_in_the_next('1 days') }.to_not raise_error
      end
    end

    context "with an invalid interval argument" do
      it "raises an argument error" do
        expect { Scheduling.starting_in_the_next('1') }.to raise_error(ArgumentError)
      end
    end
  end

  context '#comments_count' do
    let(:scheduling) { create :scheduling }
    it 'defaults to 0' do
      scheduling.comments_count.should == 0
    end

    it 'is increased when adding a comment' do
      expect do
        create :comment, commentable: scheduling
      end.to change { scheduling.reload.comments_count }.from(0).to(1)
    end

    it 'is decreased when deleting a comment' do
      comment = create :comment, commentable: scheduling
      expect do
        comment.destroy
      end.to change { scheduling.reload.comments_count }.from(1).to(0)
    end
  end

  context '#move_to_week_and_year' do
    let(:scheduling) { build :scheduling_by_quickie, quickie: '10:15-11:45' }
    let(:moving) { lambda {
      scheduling.move_to_week_and_year!(23, 2002)
    } }

    it 'changes year' do
      expect(&moving).to change { scheduling.year }.to(2002)
    end

    it 'changes week' do
      expect(&moving).to change { scheduling.week }.to(23)
    end

    it 'preserves start hour' do
      expect(&moving).not_to change { scheduling.start_hour }
    end

    it 'preserves start minute' do
      expect(&moving).not_to change { scheduling.start_minute }
    end

    it 'preserves end hour' do
      expect(&moving).not_to change { scheduling.end_hour }
    end

    it 'preserves end minute' do
      expect(&moving).not_to change { scheduling.end_minute }
    end
  end
end
