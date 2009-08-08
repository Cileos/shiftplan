class Allocation < ActiveRecord::Base
  belongs_to :employee
  belongs_to :workplace

  validates_presence_of :start, :end
  validates_presence_of :employee_id, :workplace_id
  validate :start_is_before_end, :if => lambda { |record| record.end && record.start }

  named_scope :for_week, lambda { |year, week|
    year = Time.local(year)
    day_in_week = year.beginning_of_week + (week.to_i - 1) * 7.days
    start_date, end_date = day_in_week.beginning_of_week, day_in_week.end_of_week

    Allocation.between(start_date, end_date).proxy_options
  }

  named_scope :for_year, lambda { |year|
    start_date, end_date = Date.civil(year).beginning_of_year, Date.civil(year).end_of_year
    Allocation.between(start_date, end_date).proxy_options
  }

  named_scope :for_month, lambda { |year, month|
    start_date, end_date = Date.civil(year, month).beginning_of_month, Date.civil(year, month).end_of_month
    Allocation.between(start_date, end_date).proxy_options
  }

  named_scope :for_day, lambda { |year, month, day|
    start_date, end_date = Date.civil(year, month, day), Date.civil(year, month, day)
    Allocation.between(start_date, end_date).proxy_options
  }

  named_scope :between, lambda { |start_date, end_date|
    start_date, end_date = start_date.beginning_of_day, end_date.end_of_day

    {
      :conditions => ["(start BETWEEN ? AND ?) OR (end BETWEEN ? AND ?)", start_date, end_date, start_date, end_date],
      :order => "start ASC, end ASC"
    }
  }

  private
    def start_is_before_end
      errors.add(:end_date, "muss nach dem Start sein") if self.end < self.start
    end
end
