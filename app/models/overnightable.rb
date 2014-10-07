# The importing model will support overnight timespans. When crossing the day boundary, it
# will be split into 2 parts, but only in the view.
#
# Prerequisites:
#   starts_at and ends_at are set, will only be touched if ends_at < starts_at
#
# Results:
#   ends_at fixed
#   second record spanning the time of the next day

module Overnightable
  def is_overnight?
    starts_at.day != ends_at.day
  end

  def length_in_hours_until_midnight
    (starts_at.end_of_day - starts_at) / (60*60)
  end

  def length_in_hours_from_midnight
    (ends_at - starts_at.tomorrow.beginning_of_day) / (60*60)
  end
end
