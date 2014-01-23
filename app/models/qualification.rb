class Qualification < ActiveRecord::Base
  belongs_to :account
  has_many   :schedulings
  has_many   :employee_qualifications
  has_many   :employees, through: :employee_qualifications

  validates :name, :account, presence: true
  validates_uniqueness_of :name, scope: :account_id

  def self.default_sorting
    order(:name)
  end
end
