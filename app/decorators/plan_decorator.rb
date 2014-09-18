class PlanDecorator < TabularizedRecordDecorator
  def period_modes_for_select
    %w(limited unlimited).map do |v|
      [h.t(v, scope: 'activerecord.values.plan.period_modes'), v]
    end
  end

  def durations_for_select
    Plan::Durations.map do |duration|
      [translate(duration, :scope => 'activerecord.values.plans.durations'), duration]
    end
  end

  def period_mode
    if object.starts_at.present? || object.ends_at.present?
      'limited'
    else
      'unlimited'
    end
  end
end
