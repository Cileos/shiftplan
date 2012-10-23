class WithinPlanPeriodValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.plan && record.plan.starts_at.present?
      if value.to_date < record.plan.starts_at.to_date
        record.errors[attribute] << I18n.t('activerecord.errors.models.scheduling.smaller_than_plan_start_time')
      end
    end
    if record.plan && record.plan.ends_at.present?
      if value.to_date > record.plan.ends_at.to_date
        record.errors[attribute] << I18n.t('activerecord.errors.models.scheduling.greater_than_plan_end_time')
      end
    end
  end
end
