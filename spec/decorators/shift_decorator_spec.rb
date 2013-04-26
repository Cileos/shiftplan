require 'spec_helper'

describe ShiftDecorator do

  context "#period_with_duration" do
    let(:shift_decorator) { ShiftDecorator.new(shift) }

    context "for normal shifts" do
      let(:shift) do
        create(:shift, start_hour: 8, start_minute: 15, end_hour: 16, end_minute: 45)
      end

      it "correctly computes the period with duration" do
        shift.next_day.should be_nil
        shift.previous_day.should be_nil

        shift_decorator.period_with_duration.should == "08:15-16:45 (08:30h)"
      end
    end

    context "for overnightables" do
      let(:overnightable) do
        create(:shift, start_hour: 22, start_minute: 15, end_hour: 6, end_minute: 45)
      end
      let(:expected_period) { '22:15-06:45 (08:30h)' }

      context "having a next day" do
        let(:shift) { overnightable }

        it "correctly computes the period with duration" do
          shift.next_day.should_not be_nil

          shift_decorator.period_with_duration.should == expected_period
        end
      end
      context "having a previous day" do
        let(:shift) { overnightable.next_day }

        it "correctly computes the period with duration" do
          shift_decorator.period_with_duration.should == expected_period
        end
      end
    end
  end
end
