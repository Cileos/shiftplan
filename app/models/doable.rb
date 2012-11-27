# to be included in modals which can be done (tasks, milestones etc)
module Doable
  def self.included(model)
    model.class_eval do
      validates_presence_of :name
      attr_accessible :name, :due_at, :done, :responsible_id, :description
      belongs_to :responsible, class_name: 'Employee', foreign_key: :responsible_id
    end
  end

  def due_on
    due_at.in_time_zone.to_date
  end
end
