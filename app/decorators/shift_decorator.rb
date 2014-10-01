class ShiftDecorator < RecordDecorator
  include TimePeriodFormatter
  include SchedulableDecoratorHelper
  include OvernightableDecoratorHelper

  decorates :shift
  decorates_association :demands

  delegate :is_overnight?, to: :model

  def demands_sorted_by_qualification_name
    demands.sort_by { |d| d.qualification.try(:name) || '' }
  end

  # overnightable
  def starts_on_focussed_day?
    focus_day == day
  end

  def ends_on_focussed_day?
    focus_day == day + 1
  end

  private

    # Override method of TimePeriodFormatter module since in the case of shifts
    # starts_at and ends_at are of class Time(not DateTime like for schedulings),
    # so we have to manually add 1 day to the ends_at value for overnightables.
    def length_in_minutes
      @length_in_minutes ||= if is_overnight?
        ((self_or_next_day.ends_at + 1.day) - self_or_prev_day.starts_at) / 60
      else
        (ends_at - starts_at) / 60
      end
    end
end
