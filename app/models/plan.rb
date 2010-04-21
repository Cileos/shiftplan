require 'activity_logging'

class Plan < ActiveRecord::Base
  self.activity_attrs = %w(name start end template)

  belongs_to :account

  has_many :shifts do
    def by_day
      all.group_by(&:day)
    end

    def by_workplace
      all.group_by(&:workplace)
    end
  end

  scope :templates, lambda { where(:template => true) }

  validates_presence_of :start, :end
  validate :start_before_end

  def days
    (start_date)..(end_date)
  end

  %w(start end).product(%w(date time)).each do |attribute, type|
    define_method(:"#{attribute}_#{type}") { send(attribute).send(:"to_#{type}") }
  end

  %w(start end).each do |attribute|
    define_method(:"#{attribute}_time_in_minutes") { send(attribute).hour * 60 + send(attribute).min }
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
      errors[:base] << "Start date must be before end date" unless before?(start.try(:to_date), self.end.try(:to_date))
      errors[:base] << "Start time must be before end time" unless before?(start.try(:to_time), self.end.try(:to_time))
    end

    def before?(left, right)
      left && right && (left < right)
    end
end
