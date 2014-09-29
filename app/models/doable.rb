# to be included in modals which can be done (tasks, milestones etc)
module Doable
  def self.included(model)
    model.class_eval do
      validates_presence_of :name
      belongs_to :responsible, class_name: 'Employee', foreign_key: :responsible_id
    end
  end

  def due_on
    due_at.in_time_zone.to_date
  end

  def due_on=(date)
    if date
      self.due_at = date.in_time_zone
    end
  end
end
