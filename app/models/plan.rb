class Plan < ActiveRecord::Base
  include Draper::ModelSupport
  belongs_to :organization
  has_many :schedulings

  validates_presence_of :name
  validates_presence_of :month

  # for now, durations are hardcoded, not saved
  Durations = %w(1_week)
  attr_writer :duration
  def duration
    @duration ||= Durations.first
  end

  # #week is is identified by the  #first_day
  def week
    first_day
  end
  def week=(new_week)
    self.first_day = new_week
  end

  def month
    first_day.beginning_of_month
  end

  def each_day
    days.each do |d|
      yield(first_day + (d-1).days)
    end
  end

  def days
    (1..duration_in_days).to_a
  end

  def duration_in_days
    (last_day - first_day).to_i + 1
  end

  def day_at(offset)
    (first_day + (offset.to_i - 1 ).days).to_time_in_current_zone
  end

  def employees_available?
    !organization.employees.empty?
  end

  private
  before_validation :set_last_day
  def set_last_day
    if last_day.blank? && first_day.present?
      self.last_day = first_day + 1.week - 1.day
    end
  end
end
