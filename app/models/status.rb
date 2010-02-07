class Status < ActiveRecord::Base
  VALID_STATUSES = %w(Available Unavailable)

  belongs_to :employee

  validates_presence_of :start, :end
  validates_inclusion_of :day_of_week, :in => 0..6, :allow_nil => true
  validates_inclusion_of :status, :in => VALID_STATUSES
  validate :day_or_day_of_week_needs_to_be_set

  scope :default,  where("day IS NULL AND day_of_week IS NOT NULL").order("day_of_week ASC, start ASC, end ASC")
  scope :override, where("day_of_week IS NULL AND day IS NOT NULL").order("day ASC, start ASC, end ASC")

  class << self
    def for(*args)
      start_date, end_date = *args
      end_date   ||= start_date
      date_range   = start_date..end_date
      days_of_week = date_range.map(&:wday).uniq

      statuses = where(["day BETWEEN ? AND ? OR day_of_week IN(?)", start_date, end_date, days_of_week])

      statuses = date_range.inject(ActiveSupport::OrderedHash.new) do |by_day, day|
        by_day.merge(day => begin
          for_day = statuses.select { |status| status.day == day }
          # select the defaults for the given day if no availabilities are defined
          for_day.empty? ? statuses.select { |status| status.day_of_week = day.wday } : for_day
        end)
      end

      args.size == 1 ? statuses[start_date] : statuses
    end

    def fill_gaps!(day_of_week, statuses)
      return [new(:day_of_week => day_of_week, :start => '00:00:00', :end => '00:00:00', :status => nil)] unless statuses.present?

      statuses = statuses.sort_by(&:start)

      # first and last status should be filled up from/until midnight, if necessary
      if (first_status = statuses.first).start.strftime('%H:%M:%S') != '00:00:00'
        statuses.unshift(new(first_status.attributes.merge(:start => '00:00:00', :end => first_status.start, :status => nil)))
      end

      if (last_status = statuses.last).end.strftime('%H:%M:%S') != '00:00:00'
        statuses.push(new(last_status.attributes.merge(:start => last_status.end, :end => '00:00:00', :status => nil)))
      end

      statuses.each_with_index do |status, index|
        if status != statuses.last && status.end != statuses[index+1].start
          statuses.insert(index+1, new(status.attributes.merge(:start => status.end, :end => statuses[index+1].start, :status => nil)))
        end
      end
    end
  end

  # dynamically define query methods for all statuses
  VALID_STATUSES.each do |status|
    define_method(:"#{status.underscore}?") do
      self.status == status
    end
  end

  protected

    def day_or_day_of_week_needs_to_be_set
      errors.add_to_base(I18n.t(:day_or_day_of_week_needs_to_be_set, :scope => [:activerecord, :errors, :messages])) if day.blank? && day_of_week.blank?
    end
end
