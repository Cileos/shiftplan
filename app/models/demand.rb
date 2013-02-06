class Demand < ActiveRecord::Base
  belongs_to :shift
  belongs_to :qualification
  has_many   :schedulings

  validates :quantity, presence: true
  validates_numericality_of :quantity, greater_than: 0

  # only added to make the shift features deterministic
  def self.default_scope
    order('demands.id')
  end
end
