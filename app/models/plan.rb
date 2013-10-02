class Plan < ActiveRecord::Base
  include Draper::Decoratable
  belongs_to :organization
  has_many :schedulings
  has_many :milestones
  has_many :attached_documents

  # just for ember, lacking nested URLs
  has_many :tasks, through: :milestones

  include FriendlyId
  friendly_id :name, use: [:scoped, :slugged], scope: :organization

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

  def self.default_sorting
    order(:name)
  end

  # Valid hour range for Schedulings of this plan
  # TODO: un-hardcode to customize "the workday"
  def start_hour
    0
  end
  def end_hour
    24
  end
  def hour_range
    (start_hour .. end_hour)
  end

  def minute_range
    [0,15,30,45]
  end

  def has_period?
    starts_at.present? || ends_at.present?
  end

  def period
    Plan::Period.new(starts_at, ends_at)
  end
  def build_apply_plan_template(attrs={})
    ApplyPlanTemplate.new attrs.merge(plan: self)
  end

  def filter(criteria={})
    SchedulingFilter.new(criteria.merge(plan: self))
  end
end

PlanDecorator
