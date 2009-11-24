class Plan < ActiveRecord::Base
  belongs_to :account

  has_many :shifts do
    def by_day
      all.group_by(&:day)
    end

    def by_workplace
      all.group_by(&:workplace)
    end
  end

  validates_presence_of :start_date, :end_date, :start_time, :end_time
  # before_save :set_duration

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
end
