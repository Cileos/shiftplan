class Plan
  attr_accessor :shifts

  def days
    shifts.first.start.to_date..(shifts.first.start + 6.days).to_date
  end

  def start_in_minutes
    shifts.map(&:start_in_minutes).min
  end

  def duration_in_minutes
    shifts.map(&:end_in_minutes).max - shifts.map(&:start_in_minutes).min
  end
end