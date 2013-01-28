class ShiftPeriodValidator < ActiveModel::Validator
  def validate(record)
    if record.start_hour && record.end_hour && record.start_minute && record.end_minute
      if record.start_hour == record.end_hour && record.start_minute == record.end_minute
        record.errors[:base] << I18n.t('activerecord.errors.models.shift.start_time_must_be_different_from_end_time')
      end
    end
  end
end
