class Milestone < ActiveRecord::Base
  validates_presence_of :name
  belongs_to :plan

  def due_on
    due_at.in_time_zone.to_date
  end
end
