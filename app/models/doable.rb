# to be included in modals which can be done (tasks, milestones etc)
module Doable
  Overlapse = 12.hours
  def self.included(model)
    model.class_eval do
      validates_presence_of :name
      belongs_to :responsible, class_name: 'Employee', foreign_key: :responsible_id

      extend ClassMethods
    end
  end

  def due_on
    due_at.in_time_zone.to_date
  end

  module ClassMethods
    def todo
      where('due_at is NULL OR ? < due_at', Time.zone.now.beginning_of_day - Overlapse).where('done IS NULL OR done = ?', false).order('updated_at DESC')
    end
  end
end
