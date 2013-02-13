class Qualification < ActiveRecord::Base
  belongs_to :organization
  has_many   :schedulings

  validates :name, :organization, presence: true
  validates_uniqueness_of :name, scope: :organization_id
end
