class Assignment < ActiveRecord::Base
  belongs_to :requirement
  belongs_to :employee
end
