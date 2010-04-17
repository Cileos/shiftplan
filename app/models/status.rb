class Status < ActiveRecord::Base
  VALID_STATUSES = %w(Available Unavailable)

  belongs_to :employee

  validates_inclusion_of :day_of_week, :in => 0..6, :allow_nil => true
  validates_inclusion_of :status, :in => VALID_STATUSES
  validate :day_or_day_of_week_needs_to_be_set

  scope :default,  where("day IS NULL AND day_of_week IS NOT NULL").order("day_of_week ASC, start_time ASC, end_time ASC")
  scope :override, where("day_of_week IS NULL AND day IS NOT NULL").order("day ASC, start_time ASC, end_time ASC")

  scope :with_status, lambda { |status|  }
  scope :in_range,    lambda { ||  }

  class << self
    def for(*args)
      options = args.extract_options!
      start_date, end_date = *args
      end_date   ||= start_date

      statuses = within_dates(start_date, end_date)
      statuses = statuses.within_times(options[:start_time], options[:end_time]) if options[:start_time]
      statuses = statuses.with_status(options[:status]) if options[:status]
      statuses = statuses.all

      statuses = (start_date..end_date).inject(ActiveSupport::OrderedHash.new) do |by_day, day|
        for_day = statuses.select { |status| status.day == day }
        statuses.each do |status|
          # select the default statuses for the given day if no override statuses are defined
          for_day << status.dup.tap { |status| status.day = day } if status.day_of_week == day.wday
        end if for_day.empty?
        by_day.merge(day => for_day)
      end

      args.size == 1 ? statuses[start_date] : statuses
    end
    
    def within_dates(start_date, end_date)
      where("day BETWEEN ? AND ? OR day_of_week IN(?)", start_date, end_date, (start_date..end_date).map(&:wday).uniq)
    end
    
    def within_times(start_time, end_time)
      start_time, end_time = start_time.strftime('%H:%M:%S'), end_time.strftime('%H:%M:%S')
      where("? BETWEEN start_time AND end_time AND ? BETWEEN start_time AND end_time OR start_time IS NULL", start_time, end_time)
    end
    
    def with_status(status)
      where("status = ?", status)
    end

    def fill_gaps!(employee, day_of_week, statuses)
      return [new(:employee => employee, :day_of_week => day_of_week, :start_time => '00:00:00', :end_time => '00:00:00', :status => nil)] unless statuses.present?

      statuses = statuses.sort_by(&:start_time)

      # first and last status should be filled up from/until midnight, if necessary
      if (first_status = statuses.first).start_time.strftime('%H:%M:%S') != '00:00:00'
        statuses.unshift(new(first_status.attributes.merge(:start_time => '00:00:00', :end_time => first_status.start_time, :status => nil)))
      end

      if (last_status = statuses.last).end_time.strftime('%H:%M:%S') != '00:00:00'
        statuses.push(new(last_status.attributes.merge(:start_time => last_status.end_time, :end_time => '00:00:00', :status => nil)))
      end

      statuses.each_with_index do |status, index|
        if status != statuses.last && status.end_time != statuses[index+1].start_time
          statuses.insert(index+1, new(status.attributes.merge(:start_time => status.end_time, :end_time => statuses[index+1].start_time, :status => nil)))
        end
      end
    end
  end

  # dynamically define query methods for all statuses
  VALID_STATUSES.each do |status|
    define_method(:"#{status.underscore}?") do
      self.status == status.to_s
    end
  end

  def start_time
    read_attribute(:start_time) || Time.new.midnight # should be Time.zone.new ... ?
  end

  def end_time
    read_attribute(:end_time) || Time.new.midnight
  end

  def default?
    !!day_of_week && !day
  end

  def override?
    !!day && !day_of_week
  end

  def form_values_json
    day_or_day_of_week = default? ? "day_of_week: #{day_of_week}" : "day: '#{day.to_s(:db)}'"
    statuses = Status::VALID_STATUSES.map { |status| "status_#{status.underscore}: #{send("#{status.underscore}?")}" }.join(",\n")

    json = <<-json
      {
        employee_id: #{employee.id},
        #{day_or_day_of_week},
        start_time: '#{start_time ? start_time.strftime('%H:%M') : '00:00'}',
        end_time: '#{end_time ? end_time.strftime('%H:%M') : '00:00'}',
        status: '#{status}',
        #{statuses}
      }
    json
    json.gsub("\n", ' ').strip
  end

  def to_json
    {
      'status'     => status,
      'day'        => day,
      'start_time' => start_time ? start_time.strftime('%H:%M') : '00:00',
      'end_time'   => end_time   ? end_time.strftime('%H:%M')   : '00:00'
    }.to_json
  end

  protected

    def day_or_day_of_week_needs_to_be_set
      errors[:base] << I18n.t(:day_or_day_of_week_needs_to_be_set, :scope => [:activerecord, :errors, :messages]) if day.blank? && day_of_week.blank?
    end
end
