class NextDayWithinPlanPeriodValidator < ActiveModel::Validator
  def validate(record)
    if (plan = record.plan) && plan.ends_at.present?
      if record.next_day.present? && record.next_day.ends_at > plan.ends_at.end_of_day
        record.errors[:base] << I18n.t('activerecord.errors.models.scheduling.next_day_outside_plan_period')
      end
    end
  end
end
