class ShiftDecorator < RecordDecorator
  include TimePeriodFormatter
  include OvernightableDecoratorHelper
  include SchedulableDecoratorHelper

  decorates :shift
  decorates_association :demands

  delegate :is_overnight?, :previous_day, to: :model

  def demands_sorted_by_qualification_name
    demands.sort_by { |d| d.qualification.try(:name) || '' }
  end

  private

    # Override method of TimePeriodFormatter module since in the case of shifts
    # starts_at and ends_at are of class Time(not DateTime like for schedulings),
    # so we have to manually add 1 day to the ends_at value.
    def length_in_minutes
      @length_in_minutes ||=
        ((self_or_next_day.ends_at.to_time + 1.day) -
         self_or_prev_day.starts_at.to_time) / 60
    end
end
