class WorkplaceQualification < ActiveRecord::Base
  belongs_to :workplace
  belongs_to :qualification
end
