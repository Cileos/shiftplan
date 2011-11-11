class Plan < ActiveRecord::Base
  belongs_to :organization

  validates_presence_of :name
  validates_presence_of :month

  # for now, durations are hardcoded, not saved
  Durations = %w(1_month)
  attr_writer :duration
  def duration
    @duration ||= Durations.first
  end

  # as long we have no gliding plan, #first_day will be shown as #month.
  def month
    first_day
  end
  def month=(new_month)
    self.first_day = new_month
  end

  def each_day
    (1..duration_in_days).to_a.each do |d|
      yield(first_day + (d-1).days)
    end
  end

  def duration_in_days
    (last_day - first_day).to_i + 1
  end


  private
  before_validation :set_last_day
  def set_last_day
    if last_day.blank? && first_day.present?
      self.last_day = first_day.end_of_month
    end
  end
end
