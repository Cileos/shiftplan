# TODO check against requirement model (wp req has quantity as opposed to req having one object per requirement)
class WorkplaceRequirement < ActiveRecord::Base
  belongs_to :workplace
  belongs_to :qualification

  # FIXME causes new workplace form submit to fail if default staffing given
  # validates_presence_of :workplace_id,     :if => lambda { |record| record.workplace.nil? }
  validates_presence_of :qualification_id, :if => lambda { |record| record.qualification.nil? }
end
