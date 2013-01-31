class NextDayWithinPlanPeriodValidator < ActiveModel::Validator
  def validate(record)
    if record.plan && record.plan.ends_at.present?
      if record.next_day.present? && record.next_day.ends_at > record.plan.ends_at.to_date
        record.errors[:base] << I18n.t('activerecord.errors.models.scheduling.next_day_outside_plan_period')
      end
    end
  end
end
