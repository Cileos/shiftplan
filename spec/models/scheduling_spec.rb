# encoding: utf-8

require 'spec_helper'

describe Scheduling do

  in_locale :de

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

    describe "old scheduling without week or year, synced" do
      it_behaves_like 'completely defined' do
        let :scheduling do
          s = build_without_dates({
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
    let(:nightwatch) { build :scheduling, quickie: '19-6' }

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

    context "with year and week turn" do
      let(:nightwatch) { build_without_dates quickie: '19-6', date: '2012-01-01' }

      # in germany, the week with january 4th is the first calendar week
      # in 2012, the January 1st is a sunday, so January 1st is in week 52 (of year 2011)
      it "should set year and week correctly" do
        nightwatch.save!
        nightwatch.year.should == 2011
        nightwatch.week.should == 52

        nightwatch.next_day.year.should == 2012
        nightwatch.next_day.week.should == 1
      end
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

      it "should be included in the quickie" do
        scheduling.team = team
        scheduling.team.stub(:to_quickie).and_return('<team quickie part>')
        scheduling.quickie.should == '1-23 <team quickie part>'
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
    it "should be destroyable" do
      s = Scheduling.find scheduling.id
      expect { s.destroy }.to_not raise_error(ActiveRecord::RecordNotFound)
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

  context "for plan with start and end time set" do
    let(:plan) { build :plan,
                 starts_at: Time.zone.parse('2012-12-12'),
                 ends_at:   Time.zone.parse('2012-12-13')
                }

    it "should be valid when start time and end time are within the plan period" do
      build(:scheduling, plan: plan, starts_at: Time.zone.parse('2012-12-12 8:00'),  ends_at: Time.zone.parse('2012-12-12 17:00')).should be_valid
    end

    it "should be valid when start time and end time are within the plan period (almost until midnight)" do
      build(:scheduling, plan: plan, starts_at: Time.zone.parse('2012-12-13 16:00'), ends_at: Time.zone.parse('2012-12-13 23:59')).should be_valid
    end

    it "should not be valid when the start time is smaller than the plan's start time" do
      scheduling = build(:scheduling, plan: plan, starts_at: Time.zone.parse('2012-12-11 8:00'), ends_at: Time.zone.parse('2012-12-12 8:00'))
      scheduling.should_not be_valid
      scheduling.errors[:starts_at].should == ["ist kleiner als die Startzeit des Plans"]
    end

    it "should not be valid when start time is greater than the plan's end time" do
      scheduling = build(:scheduling, plan: plan, starts_at: Time.zone.parse('2012-12-14 8:00'), ends_at: Time.zone.parse('2012-12-13 8:00'))
      scheduling.should_not be_valid
      scheduling.errors[:starts_at].should == ["ist größer als die Endzeit des Plans"]
    end

    it "should not be valid when the end time is smaller than the plan's start time" do
      scheduling = build(:scheduling, plan: plan, starts_at: Time.zone.parse('2012-12-12 8:00'), ends_at: Time.zone.parse('2012-12-11 8:00'))
      scheduling.should_not be_valid
      scheduling.errors[:ends_at].should == ["ist kleiner als die Startzeit des Plans"]
    end

    it "should not be valid when end time is greater than the plan's end time" do
      scheduling = build(:scheduling, plan: plan, starts_at: Time.zone.parse('2012-12-12 8:00'), ends_at: Time.zone.parse('2012-12-14 8:00'))
      scheduling.should_not be_valid
      scheduling.errors[:ends_at].should == ["ist größer als die Endzeit des Plans"]
    end
  end

  context "for plan with only start time set" do
    let(:plan) { build :plan,
                 starts_at: Time.zone.parse('2012-12-12'),
                 ends_at:   nil
                }

    it "should be valid when start time and end time are >= the plan's start time" do
      build(:scheduling, plan: plan, starts_at: Time.zone.parse('2012-12-12 8:00'), ends_at: Time.zone.parse('2012-12-13 8:00')).should be_valid
    end

    it "should not be valid when the start time is smaller than the plan's start time" do
      scheduling = build(:scheduling, plan: plan, starts_at: Time.zone.parse('2012-12-11 8:00'), ends_at: Time.zone.parse('2012-12-12 8:00'))
      scheduling.should_not be_valid
      scheduling.errors[:starts_at].should == ["ist kleiner als die Startzeit des Plans"]
    end

    it "should not be valid when the end time is smaller than the plan's start time" do
      scheduling = build(:scheduling, plan: plan, starts_at: Time.zone.parse('2012-12-12 8:00'), ends_at: Time.zone.parse('2012-12-11 8:00'))
      scheduling.should_not be_valid
      scheduling.errors[:ends_at].should == ["ist kleiner als die Startzeit des Plans"]
    end
  end

  context "for plan with only end time set" do
    let(:plan) { build :plan,
                 starts_at:   nil,
                 ends_at: Time.zone.parse('2012-12-12')
                }

    it "should be valid when start time and end time are <= the plan's end time" do
      build(:scheduling, plan: plan, starts_at: Time.zone.parse('2012-12-11 8:00'), ends_at: Time.zone.parse('2012-12-12 8:00')).should be_valid
    end

    it "should not be valid when the start time is greater than the plan's end time" do
      scheduling = build(:scheduling, plan: plan, starts_at: Time.zone.parse('2012-12-13 8:00'), ends_at: Time.zone.parse('2012-12-12 8:00'))
      scheduling.should_not be_valid
      scheduling.errors[:starts_at].should == ["ist größer als die Endzeit des Plans"]
    end

    it "should not be valid when the end time is greater than the plan's end time" do
      scheduling = build(:scheduling, plan: plan, starts_at: Time.zone.parse('2012-12-12 8:00'), ends_at: Time.zone.parse('2012-12-13 8:00'))
      scheduling.should_not be_valid
      scheduling.errors[:ends_at].should == ["ist größer als die Endzeit des Plans"]
    end
  end

  context "for a plan with end time" do
    let(:plan) { build :plan, ends_at: Time.zone.parse('2012-12-12') }

    it "should not be valid if the next day is outside the plan period" do
      scheduling = build_without_dates quickie: '22-6', date: '2012-12-12', plan: plan

      scheduling.should_not be_valid
      scheduling.errors[:base].should == ["Die Endzeit ist größer als die Endzeit des Plans."]
    end
  end

  # use factory except for the time range related attributes, so the
  # validity of the Scheduling is not compromised
  def build_without_dates(attrs={})
    build :scheduling, attrs.reverse_merge({
      starts_at: nil,
      ends_at:   nil,
      week:      nil,
      year:      nil,
      date:      nil
    })
  end
end
