class PeriodValidator < ActiveModel::Validator
  def validate(record)
    if record.starts_at.present? && record.ends_at.present? && record.starts_at > record.ends_at
      record.errors[:base] << I18n.t('validators.period.message')
    end
  end
end
