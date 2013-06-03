# encoding: utf-8
module Volksplaner
  module Formatter
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
    end
  end
end
