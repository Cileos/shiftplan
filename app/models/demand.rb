class Demand < ActiveRecord::Base
  has_many   :shifts, through: :demands_shifts
  has_many   :demands_shifts, class_name: 'DemandsShifts', dependent: :destroy
  belongs_to :qualification

  validates :quantity, presence: true

  # only added to make the shift features deterministic
  def self.default_scope
    order('demands.id')
  end
end
