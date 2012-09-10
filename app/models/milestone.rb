class Milestone < ActiveRecord::Base
  validates_presence_of :name
  belongs_to :plan

  attr_accessible :name, :due_at, :done

  def due_on
    due_at.in_time_zone.to_date
  end
end
