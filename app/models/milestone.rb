class Milestone < ActiveRecord::Base
  belongs_to :plan
  include Doable
end
