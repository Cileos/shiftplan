# The calendar is accessible through a weekly interface (as in "20th week of
# 1973"). We consider week numbers, be careful to use #cwyear instead of #year
# if you want to address a date by week.
#
# For example, January 1st 2012 has a cwyear of 2011 because it is still in the
# last week (52) of that year.
#
# Prerequisites:
#   attr_writer :date
#   method: date_part_or_default
#
# Result:
#   @date is set
#
module TimeRangeWeekBasedAccessible
  def self.included(model)
    model.class_eval do
      attr_writer :year, :week, :cwday
      before_validation :calculate_date_from_week_and_weekday
      extend Scopes
    end
  end
  # calculates the date manually from #year, #week and #cwday
  def build_date_from_human_attributes(year, week, cwday)
    Date.commercial(year.to_i, week.to_i, cwday.to_i)
  rescue ArgumentError => e
    raise ArgumentError, "#{e.message} from (#{year}, #{week}, #{cwday}"
  end

  def date_from_human_date_attributes
    if @cwday
      build_date_from_human_attributes(year, week, @cwday)
    end
  end

  # the year, defaults to current
  def year
    @year || date_part_or_default(:year) { Date.today.year }
  end

  # calendar week, defaults to current
  # be aware: 1 is not always the week containing Jan 1st
  def week
    @year || date_part_or_default(:cweek) { Date.today.cweek }
  end

  # calendar week day, monday is 1, Sunday is 7, defaults to current day
  def cwday
    @cwday || date_part_or_default(:wday) { Date.today.cwday }
  end

  # The year of the calendar week, may differ from year, for example for 2012-01-01
  def cwyear
    date_part_or_default(:cwyear) { Date.today.cwyear }
  end

  protected

  # year defaults to now
  def calculate_date_from_week_and_weekday
    if [@week, @cwday].all?(&:present?)
      self.date = build_date_from_human_attributes(year, @week, @cwday)
      @week = @cwday = nil
    end
  end

  module Scopes
    def between(first, last)
      where('? <= starts_at AND starts_at <= ?', first, last)
    end
  end
end
