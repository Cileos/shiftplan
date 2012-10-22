class WithinPlanPeriodValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.plan && record.plan.starts_at.present?
      if value.to_date < record.plan.starts_at.to_date
        record.errors[attribute] << "is smaller than the plan's start time"
      end
    end
    if record.plan && record.plan.ends_at.present?
      if value.to_date > record.plan.ends_at.to_date
        record.errors[attribute] << "is greater than the plan's end time"
      end
    end
  end
end
