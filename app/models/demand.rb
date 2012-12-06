class Demand < ActiveRecord::Base
  belongs_to :shift
  belongs_to :qualification

  validates :quantity, presence: true
end
