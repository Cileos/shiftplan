class Demand < ActiveRecord::Base
  has_many   :shifts, through: :demands_shifts
  has_many   :demands_shifts, class_name: 'DemandsShifts', dependent: :destroy
  belongs_to :qualification

  validates :quantity, presence: true
end
