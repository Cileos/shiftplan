class WorkplaceRequirement < ActiveRecord::Base
  belongs_to :workplace
  belongs_to :qualification, :class_name => 'Tag'
end
