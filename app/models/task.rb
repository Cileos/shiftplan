class Task < ActiveRecord::Base
  belongs_to :milestone
  include Doable
  delegate :plan, to: :milestone
end
