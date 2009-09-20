# TODO check against requirement model (wp req has quantity as opposed to req having one object per requirement)
class WorkplaceRequirement < ActiveRecord::Base
  belongs_to :workplace
  belongs_to :qualification, :class_name => 'Tag'
end
