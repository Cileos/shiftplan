class Plan < ActiveRecord::Base
  include Draper::ModelSupport
  belongs_to :organization
  has_many :schedulings

  validates_with PlanPeriodValidator
  validates_presence_of :name

  attr_accessible :name, :description, :duration, :starts_at, :ends_at

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
end

PlanDecorator
