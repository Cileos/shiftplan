class TimeComponent < Struct.new(:record, :start_or_end)
  FullTimeExp = /\A (?<hour> \d{1,2}) : (?<minute> \d{1,2}) \z/x
  ShortTimeExp = /\A (?<hour> \d{1,2}) /x # interpret the first 2 digits as hour, discard the rest

  MinuteInterval = 15

  def hour=(hour)
    @hour = hour.present?? hour.to_i : nil
  end

  def attr_name
    :"#{start_or_end}s_at"
  end

  def hour
    @hour || (record.public_send(attr_name).present? && record.public_send(attr_name).hour) || 0
  end

  def hour_present?
    @hour.present?
  end

  def metric_hour
    hour + (0.25 * minute / 15)
  end

  def time=(time)
    if m = FullTimeExp.match(time)
      self.hour = m[:hour]
      self.minute = m[:minute]
    elsif m = ShortTimeExp.match(time)
      self.hour = m[:hour]
      self.minute = 0
    end
  end

  def time
    '%02d:%02d' % [hour, minute]
  end

  def minute
    @minute || (record.public_send(attr_name).present? && record.public_send(attr_name).min) || 0
  end

  def day
    @day || (record.public_send(attr_name).present? && record.public_send(attr_name).day) || 0
  end

  def minute=(minute)
    @minute =
      if minute.present?
        minute = minute.to_i
        rounded = round_minute minute
        if minute - rounded > MinuteInterval # overflow
          self.hour = hour + 1 # must be assigned first, obviously
        end
        rounded
      else
        nil
      end
  end

  def round_minute(minute, int=MinuteInterval)
    (
      (
        (
          minute +
          int / 2 # rounding up
        ) / int
      ) * int
    ) % 60
  end
end

