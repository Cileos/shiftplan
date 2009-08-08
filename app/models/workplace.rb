class Workplace < ActiveRecord::Base
  has_many :allocations

  validates_presence_of :name
end
