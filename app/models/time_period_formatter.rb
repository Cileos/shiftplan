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
    period + ' (' + duration + 'h)'
  end

  def duration
    '%d:%02d' % [ length_in_minutes / 60, length_in_minutes % 60 ]
  end

  def period
    TimePeriodFormatter.period_with_zeros self_or_prev_day.starts_at, self_or_next_day.ends_at
  end

  private

    def self_or_prev_day
      @self_or_prev_day ||= previous_day ? previous_day : self
    end

    def self_or_next_day
      @self_or_next_day ||= next_day ? next_day : self
    end

    def length_in_minutes
      @length_in_minutes ||=
        ((self_or_next_day.ends_at) - self_or_prev_day.starts_at) / 60
    end
end
