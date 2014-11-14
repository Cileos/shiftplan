# encoding: utf-8
module Volksplaner
  module Formatter
    # based on 15-minute intervals (4 parts in an hour)
    def self.human_hours(hours)
      case (4 * (hours - hours.to_i)).round
      when 0,4
        hours.to_i.to_s
      when 1
        "#{hours.to_i}¼"
      when 2
        "#{hours.to_i}½"
      when 3
        "#{hours.to_i}¾"
      end
    rescue TypeError => e
      return '0'
    end

    def self.metric_hour_string(hours)
      case (4 * (hours - hours.to_i)).round
      when 0,4
        hours.to_i.to_s
      when 1,3
        '%0.2f' % hours
      when 2
        '%0.1f' % hours
      end
    rescue TypeError => e
      return '0'
    end

    # 5.25 => 05:15
    def self.numeric_hours_to_time_string(num)
      return '' if num.nil?
      full, frac = num.truncate, num - num.truncate
      '%02d:%02d' % [full, frac * 60]
    end

    # 05:15 => 5.25
    def self.time_string_to_numeric_hours(string)
      return if string.blank?
      if string =~ /\A(\d{1,2}):(\d{2})\z/
        $1.to_i + ($2.to_f / 60)
      end
    end
  end
end
