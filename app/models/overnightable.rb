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
end
