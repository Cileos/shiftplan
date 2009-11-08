class DefaultAvailability < ActiveRecord::Base
  belongs_to :employee
  validates_presence_of :start, :end
  validates_inclusion_of :day_of_week, :in => 0..6
end
