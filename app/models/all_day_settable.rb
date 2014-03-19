module AllDaySettable
  # depends on TimeRangeComponentsAccessible

  def self.included(model)
    model.class_eval do
      before_validation :set_times_from_all_day
      validates_with SpansAllDayValidator
    end
  end

  def set_times_from_all_day
    if all_day?
      self.starts_at = starts_at.beginning_of_day
      self.ends_at   = ends_at.end_of_day
    end
  end

  def length_in_hours
    if all_day?
      0.0
    else
      super
    end
  end

  class SpansAllDayValidator < ActiveModel::Validator
    def validate(record)
      if record.all_day?
        unless record.starts_at.hour == 0 && record.starts_at.min == 0
          record.errors[:all_day] << 'all day scheduling does not start at beginning of day'
        end
        unless record.ends_at.hour == 23 && record.ends_at.min == 59
          record.errors[:all_day] << 'all day scheduling does not end at end of day'
        end
      end
    end
  end
end

