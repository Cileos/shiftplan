class Notification::Base < ActiveRecord::Base
  self.table_name = 'notifications'

  belongs_to :employee
  belongs_to :notifiable_object, polymorphic: true

  validates_presence_of :employee
end
