class Account < ActiveRecord::Base
  has_many :organizations
  has_many :employees
  has_many :users, through: :employees

  def self.owners_and_planners
    owners.planners
  end

  def self.owners
    where(:role => 'planner')
  end

  def self.planners
    where(:role => 'owner')
  end
end
