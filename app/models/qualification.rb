class Qualification < ActiveRecord::Base
  belongs_to :organization

  validates :name, :organization, presence: true
end
