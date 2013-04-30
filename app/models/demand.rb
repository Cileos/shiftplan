class Demand < ActiveRecord::Base
  belongs_to :shift
  belongs_to :qualification

  validates :quantity, presence: true
  validates_numericality_of :quantity, greater_than: 0

  # make the shift features deterministic
  def self.default_order
    order('demands.id')
  end
end
