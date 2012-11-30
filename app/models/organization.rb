class Organization < ActiveRecord::Base
  belongs_to :account
  belongs_to :planner,    class_name: 'User'
  has_many   :employees,  through: :memberships, order: 'last_name ASC, first_name ASC'
  has_many   :plans
  has_many   :teams,      order: 'name ASC'
  has_many   :invitations
  has_many   :blogs
  has_many   :memberships

  validates_presence_of :name

  validates_presence_of :account_id

  def company_blog
    blogs.first
  end

  def planners
    account.employees.where(role: 'planner')
  end

  def owners
    account.employees.where(role: 'owner')
  end

  def employees_plus_owners_and_planners
    (employees.all + planners.all + owners.all).uniq
  end

  def adoptable_employees
    scope = account.employees
    unless employees.empty?
      scope = scope.where("employees.id NOT IN (#{employees.map(&:id).join(',')})")
    end
    scope.order_by_names
  end

  after_create :setup
  def setup
    if blogs.empty?
      blogs.create! :title => 'Company Blog'
    end
  end
end
