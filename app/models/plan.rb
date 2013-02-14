class Plan < ActiveRecord::Base
  include Draper::ModelSupport
  belongs_to :organization
  has_many :schedulings
  has_many :milestones

  # just for ember, lacking nested URLs
  has_many :tasks, through: :milestones

  validates_with PlanPeriodValidator
  validates_with PlanPeriodSurroundsSchedulingsValidator
  validates_presence_of :name
  validates_uniqueness_of :name, scope: [:organization_id]

  attr_accessible :name,
                  :description,
                  :duration,
                  :starts_at,
                  :ends_at

  # for now, durations are hardcoded, not saved
  Durations = %w(1_week)
  attr_writer :duration
  def duration
    @duration ||= Durations.first
  end

  def employees_available?
    !organization.employees.empty?
  end


  def build_copy_week(attrs={})
    CopyWeek.new attrs.merge(plan: self)
  end

  # Valid hour range for Schedulings of this plan
  # TODO: un-hardcode to customize "the workday"
  def start_hour
    0
  end
  def end_hour
    23
  end
  def hour_range
    (start_hour .. end_hour)
  end

  def build_apply_plan_template(attrs={})
    ApplyPlanTemplate.new attrs.merge(plan: self)
  end
end

PlanDecorator
