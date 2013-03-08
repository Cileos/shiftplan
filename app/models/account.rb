class Account < ActiveRecord::Base
  has_many :organizations
  has_many :employees
  has_many :users, through: :employees
  has_many :invitations, through: :organizations
  has_many :qualifications, order: 'name ASC'

  attr_accessible :name,
                  :organization_name,
                  :first_name,
                  :last_name,
                  :user_id,
                  :on_new_account

  attr_accessor :organization_name,
                :first_name,
                :last_name,
                :user_id,
                :on_new_account

  validates_presence_of :name,
                        :organization_name,
                        :first_name,
                        :last_name,
                        :user_id,
                        if: Proc.new { |a| a.on_new_account }

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

  def setup
    if persisted? and on_new_account
      organization = organizations.create!(:name => organization_name)
      organization.setup # creates the organization's blog
      e = employees.create! do |e|
        e.first_name  = first_name
        e.last_name   = last_name
        e.user_id     = user_id
        e.role        = 'owner'
      end
      organization.memberships.create!(employee: e)
    end
  end
end
