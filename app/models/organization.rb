class Organization < ActiveRecord::Base
  belongs_to :planner, :class_name => 'User'
  has_many :employees, :order => 'last_name ASC, first_name ASC'
  has_many :plans
  has_many :teams, :order => 'name ASC'
  has_many :invitations
  has_many :blogs

  validates_presence_of :name

  def company_blog
    blogs.first
  end

  def planners
    employees.where(role: 'planner')
  end
end
