class WithinPlanPeriodValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.plan.present? and value.present?
      plan = record.plan
      if plan.starts_at.present?
        if value < plan.starts_at.beginning_of_day
          record.errors[attribute] << I18n.t('activerecord.errors.models.scheduling.smaller_than_plan_start_time')
        end
      end
      if plan.ends_at.present?
        if value > plan.ends_at.end_of_day
          record.errors[attribute] << I18n.t('activerecord.errors.models.scheduling.greater_than_plan_end_time')
        end
      end
    end
  end
end
