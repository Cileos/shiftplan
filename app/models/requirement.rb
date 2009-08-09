class Requirement < ActiveRecord::Base
  has_many :allocations
  belongs_to :workplace

  validates_presence_of :start, :end
  validates_presence_of :quantity
  validates_presence_of :workplace_id

  validate :start_is_before_end, :if => lambda { |record| record.end && record.start }

  include TimeScopes

  def time_slot
    start.minute / 15
  end
  
  private
    def start_is_before_end
      errors.add(:end_date, "muss nach dem Start sein") if self.end < self.start
    end
end
