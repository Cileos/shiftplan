class Organization < ActiveRecord::Base
  belongs_to :account
  belongs_to :planner,        class_name: 'User'
  has_many   :employees,      through: :memberships
  has_many   :plans
  has_many   :teams,          order: 'name ASC'
  has_many   :invitations
  has_many   :blogs
  has_many   :posts,          through: :blogs
  has_many   :memberships
  has_many   :plan_templates

  include FriendlyId
  friendly_id :name, use: :slugged

  validates_format_of :name, with: Volksplaner::NameRegEx
  validates_presence_of :name
  validates_presence_of :account_id

  def self.default_sorting
    order('UPPER(name)')
  end

  def company_blog
    blogs.first
  end

  def qualifications
    account.qualifications
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
    scope.default_sorting
  end

  def inspect
    %Q~<#{self.class} #{id || 'new'} #{name.inspect} (account_id: #{account_id})>~
  end

  after_create :setup
  def setup
    if blogs.empty?
      blogs.create! :title => 'Company Blog'
    end
  end

  def name_with_account
    account.name + " - " + name
  end

  def to_s
    inspect
  end
end
