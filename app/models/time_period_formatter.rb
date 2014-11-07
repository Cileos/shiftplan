# Basically a model-layer decorator
module TimePeriodFormatter
  def self.period_with_zeros(from, to)
    [time_with_zeros(from), time_with_zeros(to)].compact.join('-')
  end

  def self.period_without_zeros(from, to)
    [time_without_zeros(from), time_without_zeros(to)].compact.join('-')
  end

  # show zeros only if neccessary
  def self.period(from, to)
    [time(from), time(to)].compact.join('-')
  end

  def self.wide_period(from, to)
    [time(from), time(to)].compact.join(' - ')
  end

  def self.time_with_zeros(time)
    time && time.strftime('%H:%M')
  end

  def self.time_without_zeros(time)
    time && time.hour
  end

  def self.time(t)
    return unless t
    t.min == 0 ? time_without_zeros(t) : time_with_zeros(t)
  end

  def period_with_duration
    period_with_zeros + ' (' + duration + 'h)'
  end

  def duration
    '%d:%02d' % [ length_in_minutes / 60, length_in_minutes % 60 ]
  end

  # returns 3.25 for 3 hours and 15 minutes
  # OPTIMIZE rounding
  def length_in_hours
    length_in_minutes / 60
  end

  def period
    TimePeriodFormatter.period self_or_prev_day.starts_at, self_or_next_day.ends_at
  end

  def wide_period
    TimePeriodFormatter.wide_period self_or_prev_day.starts_at, self_or_next_day.ends_at
  end

  def period_with_zeros
    TimePeriodFormatter.period_with_zeros self_or_prev_day.starts_at, self_or_next_day.ends_at
  end

  private

    def self_or_prev_day
      @self_or_prev_day ||= (respond_to?(:previous_day) && previous_day).presence || self
    end

    def self_or_next_day
      @self_or_next_day ||= (respond_to?(:next_day) && next_day).presence || self
    end

    def length_in_minutes
      @length_in_minutes ||=
        if all_day?
          (actual_length_in_hours || 0.0) * 60
        else
          ((self_or_next_day.ends_at) - self_or_prev_day.starts_at) / 60
        end
    end
end
