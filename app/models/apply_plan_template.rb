class ApplyPlanTemplate
  include ActiveAttr::Model
  include ActiveAttr::TypecastedAttributes
  include ActiveAttr::AttributeDefaults
  include Draper::ModelSupport

  attribute :plan
  attribute :plan_template_id
  attribute :target_year, type: Integer
  attribute :target_week, type: Integer

  validates_presence_of :plan, :plan_template
  validates_presence_of :target_year, :target_week

  attr_accessor :some_shifts_outside_plan_period

  def save
    Plan.transaction do
      plan_template.shifts.each do |shift|
        create_schedulings_for_shift(shift)
      end
    end
  end

  def target_day
    monday = (date_from_target_year + (target_week.to_i).weeks).beginning_of_week
    # TODO: adjustment can hopefully be removed with new cweek refactoring from niklas
    monday = monday - (monday.cweek - target_week).weeks
  end

  def date_from_target_year
    Date.new(target_year.to_i)
  end

  def plan_template
    @plan_template ||= PlanTemplate.find(plan_template_id)
  end

  def create_schedulings_for_shift(shift)
    base_date = target_day + shift.day.days
    starts_at = base_date + shift.starts_at.hour.hours + shift.starts_at.min.minutes
    ends_at   = base_date + shift.ends_at.hour.hours + shift.ends_at.min.minutes
    shift.demands.each do |demand|
      demand.quantity.times do
        create_scheduling(
          starts_at: starts_at,
          ends_at:   ends_at,
          team:      shift.team,
          week:      target_week,
          year:      target_year,
          demand:    demand
        )
      end
    end
  end

  def create_scheduling(attrs={})
    begin
      scheduling = plan.schedulings.new(attrs)
      scheduling.save!
    rescue
      if scheduling.errors[:starts_at].present? || scheduling.errors[:ends_at].present?
        self.some_shifts_outside_plan_period = true
      else
        raise ApplyPlanTemplateError
      end
    end
  end

  class ApplyPlanTemplateError < StandardError; end
end

ApplyPlanTemplateDecorator
