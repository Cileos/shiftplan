require 'activity'

class Plan < ActiveRecord::Base
  self.activity_attrs = %w(name start_date end_date template)

  belongs_to :account

  has_many :shifts do
    def by_day
      all.group_by(&:day)
    end

    def by_workplace
      all.group_by(&:workplace)
    end
  end

  scope :templates, where(:template => true)

  validates_presence_of :start_date, :end_date, :start_time, :end_time
  validate :start_before_end

  def initialize(*args)
    super
    self.start_date ||= Date.today.beginning_of_week + 7.days
    self.end_date   ||= start_date + 5.days
    self.start_time ||= Time.parse('08:00')
    self.end_time   ||= Time.parse('18:00')
  end

  def days
    (start_date)..(end_date)
  end

  def start_time_in_minutes
    start_time.hour * 60 + start_time.min
  end

  def end_time_in_minutes
    end_time.hour * 60 + end_time.min
  end

  def duration
    @duration ||= end_time_in_minutes - start_time_in_minutes
  end

  def copy_from(other, options = {})
    offset = (start_date - other.start_date).days
    other.shifts.each do |shift|
      shift = shift.clone(options)
      shift.start += offset
      shift.end   += offset
      shifts << shift if shift.start.to_date <= end_date
    end
  end

  def form_values_json
    json = <<-json
      {
        name:       '#{name}',
        start_date: '#{start_date}',
        end_date:   '#{end_date}',
        created_at: '#{created_at}',
        updated_at: '#{updated_at}',
        start_time: '#{start_time.strftime('%H:%M')}',
        end_time:   '#{end_time.strftime('%H:%M')}'
      }
    json
    json.gsub("\n", ' ').strip
  end

  protected

    def start_before_end
      errors[:base] << "Start date must be before end date" unless self.start_date && self.end_date && self.start_date < self.end_date
      errors[:base] << "Start time must be before end time" unless self.start_time && self.end_time && self.start_time < self.end_time
    end
end
