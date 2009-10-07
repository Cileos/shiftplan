class Plan < ActiveRecord::Base
  has_many :shifts

  before_validation :set_duration

  def days
    (self.start.to_date)..(self.end.to_date)
  end

  def start_time_in_minutes
    self.start.hour * 60 + self.start.min
  end

  def end_time_in_minutes
    self.end.hour * 60 + self.end.min
  end

  protected

    def set_duration
      self.duration = end_time_in_minutes - start_time_in_minutes
    end
end