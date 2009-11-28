class Status < ActiveRecord::Base
  VALID_STATUSES = %w(Available Unavailable)

  belongs_to :employee

  validates_presence_of :start, :end
  validates_inclusion_of :day_of_week, :in => 0..6, :allow_nil => true
  validates_inclusion_of :status, :in => VALID_STATUSES

  named_scope :default,  :conditions => "day IS NULL AND day_of_week IS NOT NULL"
  named_scope :override, :conditions => "day_of_week IS NULL AND day IS NOT NULL"

  class << self
    def for(*args)
      start_date, end_date = *args
      end_date   ||= start_date
      date_range   = start_date..end_date
      days_of_week = date_range.map(&:wday).uniq

      statuses = all(:conditions => ["day BETWEEN ? AND ? OR day_of_week IN(?)", start_date, end_date, days_of_week])

      statuses = date_range.inject(ActiveSupport::OrderedHash.new) do |by_day, day|
        by_day.merge(day => begin
          for_day = statuses.select { |status| status.day == day }
          # select the defaults for the given day if no availabilities are defined
          for_day.empty? ? statuses.select { |status| status.day_of_week = day.wday } : for_day
        end)
      end

      args.size == 1 ? statuses[start_date] : statuses
    end
  end

  # dynamically define query methods for all statuses
  VALID_STATUSES.each do |status|
    define_method(:"#{status.underscore}?") do
      self.status == status
    end
  end
end
