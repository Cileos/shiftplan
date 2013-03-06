class Account < ActiveRecord::Base
  has_many :organizations
  has_many :employees
  has_many :users, through: :employees
  has_many :invitations, through: :organizations
  has_many :qualifications, order: 'name ASC'

  def self.owners_and_planners
    owners.planners
  end

  # WTF should these not be included in and  access employees?
  def self.owners
    where(:role => 'planner')
  end

  def self.planners
    where(:role => 'owner')
  end

  def to_s
    %Q~<Account #{id} "#{name}">~
  end
end
