class Task < ActiveRecord::Base
  belongs_to :milestone
  include Doable
end
