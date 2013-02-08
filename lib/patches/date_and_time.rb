module Iso8601CalendarWeek
  # Returns the year for the cweek at/of the date.
  # In germany and ISO 8601, the week with january 4th is the first calendar week.
  # E.g., in 2012, the January 1st is a sunday, so January 1st is in week 52 (of year 2011).
  #
  # PostgreSQL and Ruby implement it this way, but the latter does not ad the
  # method to all Time classes.
  def cwyear
    to_date.cwyear
  end
end

class ActiveSupport::TimeWithZone
  include Iso8601CalendarWeek
  def cweek
    to_date.cweek
  end
end

class Time
  include Iso8601CalendarWeek
end
