class Allocation < ActiveRecord::Base
  belongs_to :requirement
  belongs_to :employee
  belongs_to :workplace

  validates_presence_of :start, :end, :unless => lambda { |record| record.requirement_id }
  validates_presence_of :employee_id, :workplace_id
  validate :start_is_before_end, :if => lambda { |record| record.end && record.start }

  include TimeScopes

  private
    def start_is_before_end
      errors.add(:end_date, "muss nach dem Start sein") if self.end < self.start
    end
end
