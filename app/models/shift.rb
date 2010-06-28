require 'activity'

class Shift < ActiveRecord::Base
  self.activity_attrs = %w(start end)

  belongs_to :plan
  belongs_to :workplace
  has_many :requirements

  # validates_presence_of :plan_id, :if => lambda { |record| record.plan.nil? }
  validates_presence_of :start, :end
  validate :start_before_end

  before_validation :synchronize_duration_end_time, :if => lambda { |shift| !!shift.start }

  def start_in_minutes
    start.hour * 60 + start.min
  end

  def end_in_minutes
    start_in_minutes + duration
  end

  # temporary?
  def day
    start.to_date
  end

  def build_requirements
    workplace.workplace_requirements.each do |requirement|
      requirement.quantity.times { requirements.build(:qualification => requirement.qualification) }
    end if workplace
  end

  def copy_from(other, options = {})
    other.requirements.each { |requirement| requirements << requirement.clone(options) }
  end

  def clone(options = {})
    clone = super()
    clone.plan = nil
    clone.copy_from(self, options) if Array(options[:copy]).include?('requirements')
    clone
  end

  def log_create
    { :to => super[:to].merge!(:plan => plan.name, :workplace => workplace.name) }
  end
  alias :log_destroy :log_create

  def requirements_were_fixed
    requirement_ids_were.empty? ? [] : requirements_were
  end

  # FIXME: is this scoped on accounts? doesn't look like it
  def statused_employee_ids(status) # according to webster this is a verb
    @statused_employee_ids = {}
    @statused_employee_ids[status] ||=
      Status.for(day, :status => status, :start_time => self.start, :end_time => self.end).map(&:employee_id).uniq
  end

  # TODO: test
  def assigned_employees
    requirements.map(&:assignee).compact
  end

  protected

    def synchronize_duration_end_time
      if self.duration && self.end.nil?
        self.end = self.start + self.duration.minutes
      elsif self.end
        self.duration = ((self.end - self.start) / 60).round
      end
    end

    def start_before_end
      errors[:base] << ("Start must be before end") unless self.start && self.end && self.start < self.end
    end
end
