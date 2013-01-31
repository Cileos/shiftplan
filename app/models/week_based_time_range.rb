# The calendar is accessible through a weekly interface (as in "20th week of 1973"). We consider week numbers, 
#
# Prerequisites:
#   attr_writer :date
#   method: date_part_or_default
#
# Result:
#   @date is set
#
module WeekBasedTimeRange
  def self.included(model)
    model.class_eval do
      attr_writer :year, :week, :cwday
      before_validation :calculate_date_from_week_and_weekday
      extend Scopes
    end
  end
  # calculates the date manually from #year, #week and #cwday
  def build_date_from_human_attributes(year, week, cwday)
    ( Date.new(year.to_i) + week.to_i.weeks ).beginning_of_week + (cwday.to_i - 1).days
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
    # ActiveRecord casts all timestamps to UTC before storing them without any
    # timestamp in the DB. To search (extract) ie. the calendar week, we have to
    # (1) interpret the saved timestamps as UTC and
    # (2) convert them to our current (ruby) time zone.
    def where_date_part_equals_in_time_zone(field, date_part, value)
      where("EXTRACT(#{date_part.upcase} FROM timezone(INTERVAL ?, timezone('UTC', #{table_name}.#{field})) ) = ?", Time.zone.formatted_offset, value)
    end
    def in_year(year)
      where_date_part_equals_in_time_zone('starts_at', 'YEAR', year)
    end

    def in_week(week)
      where_date_part_equals_in_time_zone('starts_at', 'WEEK', week)
    end
  end

end
