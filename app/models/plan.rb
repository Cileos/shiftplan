class Plan < ActiveRecord::Base
  has_many :shifts do
    def by_day
      all.group_by(&:day)
    end
  end

  before_validation :set_duration

  def days
    (start.to_date)..(self.end.to_date)
  end

  def start_time_in_minutes
    start.hour * 60 + start.min
  end

  def end_time_in_minutes
    self.end.hour * 60 + self.end.min
  end

  protected

    def set_duration
      self.duration = end_time_in_minutes - start_time_in_minutes
    end
end