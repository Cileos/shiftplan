class Notification < ActiveRecord::Base
  belongs_to :employee
  belongs_to :notifiable_object, polymorphic: true

  validates_presence_of :employee
end
