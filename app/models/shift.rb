class Shift < ActiveRecord::Base
  belongs_to :workplace

  validates_presence_of :start, :end
  # TODO: validate workplace? validate :end after :start?

  def duration
    self.end - self.start
  end

  def duration_in_minutes
    (duration / 1.minute).round
  end
end
