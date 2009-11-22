class Availability < ActiveRecord::Base
  belongs_to :employee
  validates_presence_of :start, :end
  validates_inclusion_of :day_of_week, :in => 0..6

  named_scope :default,  :conditions => "day IS NULL AND day_of_week IS NOT NULL"
  named_scope :override, :conditions => "day_of_week IS NULL AND day IS NOT NULL"
end
