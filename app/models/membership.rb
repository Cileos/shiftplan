class Membership < ActiveRecord::Base
  belongs_to :organization
  belongs_to :employee

  validates_uniqueness_of :employee_id, scope: :organization_id
end
