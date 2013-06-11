require 'spec_helper'

describe TimePeriodFormatter do
  before :each do
    class DecoratorForRecordWithTimes < RecordDecorator
      include TimePeriodFormatter
    end
  end
  let(:decorator) { DecoratorForRecordWithTimes.new(record) }
  let(:record) { stub }

  context "#period_with_duration" do
    it 'is composed of period_with_zeros and duration' do
      decorator.stub period_with_zeros: '12-noon', duration: 'less than 1'
      decorator.period_with_duration.should == '12-noon (less than 1h)'
    end
  end

  context '#duration' do
    it 'normalizes minutes and hour'
  end

  context "#period_with_zeros" do

    context "for regular daytime records with minutes" do
      let(:record) { stub "regular",
                     starts_at: Time.zone.parse('8:15'),
                     ends_at: Time.zone.parse('16:45'),
                     next_day: nil, previous_day: nil
      }

      it "displays minutes" do
        decorator.period_with_zeros.should == "08:15-16:45"
      end
    end

    context "for regular daytime records with full hours" do
      let(:record) { stub "regular",
                     starts_at: Time.zone.parse('8:00'),
                     ends_at: Time.zone.parse('16:45'),
                     next_day: nil, previous_day: nil
      }

      it "displays zeros for minutes" do
        decorator.period_with_zeros.should == "08:00-16:45"
      end
    end

    context "for overnightables" do
      let(:overnightable) { stub 'overnightable',
                            starts_at: Time.zone.parse('22:15'),
                            ends_at: Time.zone.parse('06:45'),
                            next_day: next_day, previous_day: nil
      }
      let(:next_day) { stub 'next day',
                       next_day: nil,
                       ends_at: Time.zone.parse('06:45')
      }
      let(:expected_period) { '22:15-06:45' }

      context "having a next day" do
        let(:record) { overnightable }

        it "starts today, ends at next day" do
          decorator.period_with_zeros.should == expected_period
        end
      end
      context "having a previous day" do
        let(:record) { next_day }
        before :each do
          next_day.stub previous_day: overnightable # avoid recursion for let()
        end

        it "starts yesterday, ends today" do
          decorator.period_with_zeros.should == expected_period
        end
      end
    end
  end

end
