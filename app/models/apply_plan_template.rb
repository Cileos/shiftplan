class ApplyPlanTemplate
  include ActiveAttr::Model
  include ActiveAttr::TypecastedAttributes
  include ActiveAttr::AttributeDefaults
  include Draper::Decoratable

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

  def monday
    Date.commercial(target_year, target_week, 1).in_time_zone
  end

  def plan_template
    @plan_template ||= PlanTemplate.find(plan_template_id)
  end

  def create_schedulings_for_shift(shift)
    starts_at, ends_at = starts_at_and_ends_at_for(shift)
    default_attrs = {
      starts_at: starts_at,
      ends_at: ends_at,
      team: shift.team,
      all_day: shift.all_day?,
      actual_length_in_hours: shift.actual_length_in_hours,
    }
    if shift.demands.empty?
      create_scheduling(default_attrs)
    else
      shift.demands.each do |demand|
        demand.quantity.times do
          create_scheduling(default_attrs.merge(qualification: demand.qualification))
        end
      end
    end
  end

  # TODO this repeats logic from Shift
  def starts_at_and_ends_at_for(shift)
    base_date = monday + shift.day.days
    starts_at = base_date + shift.start_hour.hours + shift.start_minute.minutes
    ends_at   = base_date + shift.end_hour.hours   + shift.end_minute.minutes
    ends_at = ends_at.tomorrow if ends_at < starts_at
    *saved = starts_at, ends_at
  end

  def create_scheduling(attrs={})
    begin
      scheduling = plan.schedulings.new(attrs)
      scheduling.save!
    rescue ActiveRecord::RecordInvalid => e
      if scheduling.errors[:starts_at].present? || scheduling.errors[:ends_at].present?
        self.some_shifts_outside_plan_period = true
      else
        raise ApplyPlanTemplateError, e
      end
    ensure
      created_schedulings << scheduling
    end
  end

  def created_schedulings
    @created_schedulings ||= []
  end

  class ApplyPlanTemplateError < StandardError; end
end

ApplyPlanTemplateDecorator
