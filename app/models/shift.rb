class Shift < ActiveRecord::Base
  belongs_to :workplace
  has_many :requirements

  validates_presence_of :start, :end
  # TODO: validate workplace? validate :end after :start?

  before_create :build_requirements

  default_scope :order => "start ASC, end ASC"

  def duration
    self.end - self.start
  end

  def duration_in_minutes
    (duration / 1.minute).round
  end

  def start_in_minutes
    start.hour * 60 + start.min
  end

  # temporary?
  def day
    start.to_date
  end

  protected

    def build_requirements
      workplace.workplace_requirements.each do |requirement|
        requirement.quantity.times { requirements.build(:qualification => requirement.qualification) }
      end
    end
end
