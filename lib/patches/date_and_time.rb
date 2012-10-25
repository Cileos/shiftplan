class ActiveSupport::TimeWithZone
  def cweek
    to_date.cweek
  end
end


# Returns the year for the cweek at/of the date.
# In germany, the week with january 4th is the first calendar week.
# E.g., in 2012, the January 1st is a sunday, so January 1st is in week 52 (of year 2011).
class Date
  def year_for_cweek
    if month == 1 && cweek > 5
      year - 1
    elsif month == 12 && cweek == 1
      year + 1
    else
      year
    end
  end
end
