class Task < ActiveRecord::Base
  belongs_to :milestone
  include Doable
  attr_accessible :milestone_id # cannot nest routes thx to ember
end
