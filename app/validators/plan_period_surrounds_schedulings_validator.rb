class PlanPeriodSurroundsSchedulingsValidator < ActiveModel::Validator
  def validate(record)
    if record.schedulings.present?
      if record.starts_at.present?
        smallest_scheduling = record.schedulings.order(:starts_at).first
        if record.starts_at.to_date > smallest_scheduling.starts_at.to_date
          record.errors[:starts_at] << I18n.t('activerecord.errors.models.plan.start_date_too_small',
            date_of_smallest_scheduling: I18n.localize(smallest_scheduling.starts_at.to_date, format: :default))
        end
      end
    end
  end
end
