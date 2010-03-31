class Date
  class << self
    # According to ISO 8601, the first calendar week of a year is the week
    # containing the first Thursday. Therefor, if the first day of a year is
    # a Friday, Saturday or Sunday, we need to shift the start of the year by
    # one week.
    #
    # See http://en.wikipedia.org/wiki/ISO_8601 for details.
    #
    # TODO: edge cases, e.g. week 53 in a year with only 52 weeks
    #
    def week(year, week_number)
      raise ArgumentError.new('given week must be within 1..53') unless (1..53).include?(week_number)
      raise ArgumentError.new('given year only has 52 weeks') if weeks_in_year(year) < week_number

      week_start = first_monday_in_year(year) + (week_number - 1).weeks
      week_start.to_date..week_start.end_of_week.to_date
    end

    def first_monday_in_year(year)
      ([0, 5, 6].include?(civil(year).wday) ?
        civil(year) + 1.week : # first days of year are considered part of old year
        civil(year)).beginning_of_week.to_date
    end

    def weeks_in_year(year)
      # Apparently, 53 weeks are only possible if the 1st Januar of the following year is a Friday.
      # Not sure this is 100% correct, but it's correct until at least 2026 which should be enough
      # for shiftplan. ;-P
      civil(year + 1).wday == 5 ? 53 : 52
    end

    def same_year?(date_1, date_2)
      raise ArgumentError.new('must pass a date/time') unless date_1.respond_to?(:strftime) && date_2.respond_to?(:strftime)
      date_1.strftime('%Y') == date_2.strftime('%Y')
    end

    def same_month?(date_1, date_2)
      raise ArgumentError.new('must pass a date/time') unless date_1.respond_to?(:strftime) && date_2.respond_to?(:strftime)
      date_1.strftime('%Y%m') == date_2.strftime('%Y%m')
    end
  end

  def same_year_as?(other)
    self.class.same_year?(self, other)
  end

  def same_month_as?(other)
    self.class.same_month?(self, other)
  end
end
