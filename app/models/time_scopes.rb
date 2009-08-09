module TimeScopes
  def self.included(target)
    target.class_eval do
      named_scope :for_week, lambda { |year, week|
        year = Time.local(year)
        day_in_week = year.beginning_of_week + (week.to_i - 1) * 7.days
        start_date, end_date = day_in_week.beginning_of_week, day_in_week.end_of_week

        self.between(start_date, end_date).proxy_options
      }

      named_scope :for_year, lambda { |year|
        start_date, end_date = Date.civil(year).beginning_of_year, Date.civil(year).end_of_year
        self.between(start_date, end_date).proxy_options
      }

      named_scope :for_month, lambda { |year, month|
        start_date, end_date = Date.civil(year, month).beginning_of_month, Date.civil(year, month).end_of_month
        self.between(start_date, end_date).proxy_options
      }

      named_scope :for_day, lambda { |year, month, day|
        start_date, end_date = Date.civil(year, month, day), Date.civil(year, month, day)
        self.between(start_date, end_date).proxy_options
      }

      named_scope :between, lambda { |start_date, end_date|
        start_date, end_date = start_date.beginning_of_day, end_date.end_of_day

        {
          :conditions => ["(start BETWEEN ? AND ?) OR (end BETWEEN ? AND ?)", start_date, end_date, start_date, end_date],
          :order => "start ASC, end ASC"
        }
      }
    end
  end
end