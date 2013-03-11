module TimePeriodFormatter
  def period_with_duration
    period + ' (' + duration + 'h)'
  end

  def duration
    "#{hours}:#{minutes}"
  end

  def period
    "#{formatted_start_time}-#{formatted_end_time}"
  end

  private

    def formatted_start_time
      formatted_time(self_or_prev_day.starts_at.hour,
                     self_or_prev_day.starts_at.min)
    end

    def formatted_end_time
      formatted_time(self_or_next_day.end_hour, self_or_next_day.end_minute)
    end

    def self_or_prev_day
      @self_or_prev_day ||= previous_day ? previous_day : self
    end

    def self_or_next_day
      @self_or_next_day ||= next_day ? next_day : self
    end

    def formatted_time(hour, minute)
      "#{normalize(hour)}:#{normalize(minute)}"
    end

    def normalize(number)
      number = 0 if number.nil?
      "%02d" % number
    end

    def hours
      @hours ||= normalize((length_in_minutes / 60).to_i)
    end

    def minutes
      @minutes ||= normalize((length_in_minutes % 60).to_i)
    end

    def length_in_minutes
      @length_in_minutes ||=
        ((self_or_next_day.ends_at) - self_or_prev_day.starts_at) / 60
    end
end
