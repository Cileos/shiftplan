require 'spec_helper'

describe TimePeriodFormatter do
  before :each do
    class DecoratorForRecordWithTimes < RecordDecorator
      include TimePeriodFormatter
    end
  end
  let(:decorator) { DecoratorForRecordWithTimes.new(record) }
  let(:record) { instance_double 'Scheduling' }

  context "#period_with_duration" do
    it 'is composed of period_with_zeros and duration' do
      decorator.stub period_with_zeros: '12-noon', duration: '(less than 1h)'
      decorator.period_with_duration.should == '12-noon (less than 1h)'
    end
  end

  context '#duration' do
    it 'normalizes minutes and hour' do
      decorator.stub all_day?: false, starts_at: Time.zone.now, ends_at: 3.hours.from_now + 15.minutes
      decorator.duration.should == '(3:15h)'
    end
  end

  context "#period_with_zeros" do

    context "for regular daytime records with minutes" do
      let(:record) { instance_double "Scheduling",
                     starts_at: Time.zone.parse('8:15'),
                     ends_at: Time.zone.parse('16:45')
      }

      it "displays minutes" do
        decorator.period_with_zeros.should == "08:15-16:45"
      end
    end

    context "for regular daytime records with full hours" do
      let(:record) { instance_double "Scheduling",
                     starts_at: Time.zone.parse('8:00'),
                     ends_at: Time.zone.parse('16:45')
      }

      it "displays zeros for minutes" do
        decorator.period_with_zeros.should == "08:00-16:45"
      end
    end

    context "for overnightables" do
      let(:overnightable) { instance_double 'Scheduling',
                            starts_at: Time.zone.parse('2014-09-24 22:15'),
                            ends_at: Time.zone.parse('2014-09-25 06:45')
      }
      let(:expected_period) { '22:15-06:45' }

      context "having a next day" do
        let(:record) { overnightable }

        it "starts today, ends at next day" do
          decorator.period_with_zeros.should == expected_period
        end
      end
    end
  end

end
