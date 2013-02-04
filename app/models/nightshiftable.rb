# The importing Model will support nightshifts: When crossing the day boundary, it will be split into 2 parts.
#
# Prerequisites:
#   starts_at and ends_at are set, will only be touched if ends_at < starts_at
#
# Results:
#   ends_at fixed
#   second record spanning the time of the next day
module Nightshiftable

  def self.included(model)
    model.class_eval do
      with_options class_name: name do |self_ref|
        self_ref.belongs_to :next_day
        self_ref.belongs_to :previous_day, foreign_key: 'next_day_id'
      end
      before_validation :build_next_day_for_nightshift, if: Proc.new { |r| [r.starts_at, r.ends_at].none?(&:blank?) }
    end
  end

  protected

  def build_next_day_for_nightshift
    if ends_at < starts_at
      self.next_day = dup.tap do |tomorrow|
        tomorrow.quickie = nil
        tomorrow.starts_at = ends_at.tomorrow.beginning_of_day
        tomorrow.ends_at = ends_at + 1.day
        tomorrow.next_day = nil
      end
      self.ends_at = ends_at.end_of_day
    end
  end

  # DateTime#end_of_day returns 23:59:59, which we show as 24 o'clock
  def end_hour_respecting_end_of_day
    if ends_at.min >= 59 and ends_at.hour == 23
      24
    else
      ends_at.hour
    end
  end

end
