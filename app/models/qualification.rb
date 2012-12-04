class Qualification < ActiveRecord::Base
  belongs_to :organization

  validates :name, :organization, presence: true
  validates_uniqueness_of :name, scope: :organization_id
end
