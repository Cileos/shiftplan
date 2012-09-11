class Milestone < ActiveRecord::Base
  belongs_to :plan
  has_many :tasks
  include Doable
end
