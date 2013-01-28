class DemandsShifts < ActiveRecord::Base
  belongs_to :shift
  belongs_to :demand
end
