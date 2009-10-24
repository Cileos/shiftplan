class Shift < ActiveRecord::Base
  belongs_to :workplace
  has_many :requirements
  belongs_to :plan

  validates_presence_of :start, :end
  validate :start_before_end

  before_create :build_requirements
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

  protected

    def synchronize_duration_end_time
      if self.duration && self.end.nil?
        self.end = self.start + self.duration.minutes
      elsif self.end
        self.duration = ((self.end - self.start) / 60).round
      end
    end

    def build_requirements
      workplace.workplace_requirements.each do |requirement|
        requirement.quantity.times { requirements.build(:qualification => requirement.qualification) }
      end if workplace
    end

    def start_before_end
      errors.add_to_base("Start must be before end") unless self.start && self.end && self.start < self.end
    end
end
