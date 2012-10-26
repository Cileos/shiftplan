class PlanPeriodValidator < ActiveModel::Validator
  def validate(record)
    if record.starts_at.present? && record.ends_at.present? && record.starts_at > record.ends_at
      record.errors[:base] << I18n.t('activerecord.errors.models.plan.plan_period')
    end
  end
end
