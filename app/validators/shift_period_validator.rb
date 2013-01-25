class ShiftPeriodValidator < ActiveModel::Validator
  def validate(record)
    if record.start_hour.present? && record.end_hour.present? && record.start_hour >= record.end_hour
      record.errors[:base] << I18n.t('activerecord.errors.models.shift.shift_period')
    end
  end
end
