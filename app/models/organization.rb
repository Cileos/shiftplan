class Organization < ActiveRecord::Base
  belongs_to :account
  belongs_to :planner,    :class_name => 'User'
  has_many   :employees,  :order => 'last_name ASC, first_name ASC'
  has_many   :plans
  has_many   :teams,      :order => 'name ASC'
  has_many   :invitations
  has_many   :blogs
  has_many   :memberships

  validates_presence_of :name

  def company_blog
    blogs.first
  end

  def planners
    employees.where(role: 'planner')
  end

  def owners
    employees.where(role: 'owner')
  end

  def setup
    if blogs.empty?
      blogs.create! :title => 'Company Blog'
    end
  end
end
