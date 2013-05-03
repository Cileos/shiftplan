class Qualification < ActiveRecord::Base
  belongs_to :account
  has_many   :schedulings

  validates :name, :account, presence: true
  validates_uniqueness_of :name, scope: :account_id

  def self.default_sorting
    order(:name)
  end
end
