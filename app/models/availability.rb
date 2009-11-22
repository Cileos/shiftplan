class Availability < ActiveRecord::Base
  belongs_to :employee
  validates_presence_of :start, :end
  validates_inclusion_of :day_of_week, :in => 0..6, :allow_nil => true

  named_scope :default,  :conditions => "day IS NULL AND day_of_week IS NOT NULL"
  named_scope :override, :conditions => "day_of_week IS NULL AND day IS NOT NULL"

  class << self
    def for(*args)
      start_date, end_date = *args
      end_date   ||= start_date
      date_range   = start_date..end_date
      days_of_week = date_range.map(&:wday).uniq

      availabilities = all(:conditions => ["day BETWEEN ? AND ? OR day_of_week IN(?)", start_date, end_date, days_of_week])

      availabilities = date_range.inject(ActiveSupport::OrderedHash.new) do |by_day, day|
        by_day.merge(day => begin
          for_day = availabilities.select { |a| a.day == day }
          # select the defaults for the given day if no availabilities are defined
          for_day.empty? ? availabilities.select { |a| a.day_of_week = day.wday } : for_day
        end)
      end

      args.size == 1 ? availabilities[start_date] : availabilities
    end
  end
end
