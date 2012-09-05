class Milestone < ActiveRecord::Base
  validates_presence_of :name
  belongs_to :plan
end
