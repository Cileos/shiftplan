require 'spec_helper'

describe Scheduling do

  context "time range" do
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

  end

  # or fasterererer access
  context "syncing" do
    it "should set week"
    it "should set year"
  end
end
