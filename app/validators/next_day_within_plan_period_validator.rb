class NextDayWithinPlanPeriodValidator < ActiveModel::Validator
  def validate(record)
    if record.plan && record.plan.ends_at.present?
      if record.next_day_end_hour.present? && (record.date + 1.day) > record.plan.ends_at.to_date
        record.errors[:base] << I18n.t('activerecord.errors.models.scheduling.next_day_outside_plan_period')
      end
    end
  end
end
