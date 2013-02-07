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
      plan_template.shifts.select { |s| !s.previous_day.present? }.each do |shift|
        create_schedulings_for_shift(shift)
      end
    end
  end

  def monday
    Date.commercial(target_year, target_week, 1)
  end

  def plan_template
    @plan_template ||= PlanTemplate.find(plan_template_id)
  end

  def create_schedulings_for_shift(shift)
    base_date = monday + shift.day.days
    starts_at = base_date + shift.starts_at.hour.hours + shift.starts_at.min.minutes
    if shift.next_day
      ends_at = base_date + shift.next_day.ends_at.hour.hours + shift.next_day.ends_at.min.minutes
    else
      ends_at = base_date + shift.ends_at.hour.hours + shift.ends_at.min.minutes
    end
    shift.demands.each do |demand|
      demand.quantity.times do
        create_scheduling(
          starts_at: starts_at,
          ends_at:   ends_at,
          team:      shift.team,
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
