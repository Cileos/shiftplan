class Scheduling < ActiveRecord::Base
  belongs_to :plan
  belongs_to :employee
end
