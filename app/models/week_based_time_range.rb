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

  protected

  # year defaults to now
  def calculate_date_from_week_and_weekday
    if [@week, @cwday].all?(&:present?)
      self.date = build_date_from_human_attributes(year, @week, @cwday)
      @week = @cwday = nil
    end
  end

  module Scopes
    def in_year(year)
      where("EXTRACT(YEAR FROM #{table_name}.starts_at) = ?", year)
    end

    def in_week(week)
      where("EXTRACT(WEEK FROM #{table_name}.starts_at) = ?", week)
    end
  end

end
