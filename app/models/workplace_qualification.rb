class WorkplaceQualification < ActiveRecord::Base
  belongs_to :workplace
  belongs_to :qualification

  validates_presence_of :workplace_id,     :if => lambda { |record| record.workplace.nil? }
  validates_presence_of :qualification_id, :if => lambda { |record| record.qualification.nil? }
end
