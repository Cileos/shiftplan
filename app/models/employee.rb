class Employee < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader

  Roles = %w(owner planner)

  attr_accessible :first_name,
                  :last_name,
                  :weekly_working_time,
                  :avatar,
                  :avatar_cache,
                  :organization_id,
                  :account_id,
                  :role,
                  :force_create_duplicate
  attr_accessor :organization_id,
                :force_create_duplicate

  validates_presence_of :first_name, :last_name
  validates_numericality_of :weekly_working_time, allow_nil: true, greater_than_or_equal_to: 0
  validates_inclusion_of :role, in: Roles, allow_blank: true

  belongs_to :user
  belongs_to :account
  has_one    :invitation
  has_many   :posts, foreign_key: :author_id
  has_many   :comments
  has_many   :schedulings
  has_many   :organizations, through: :memberships
  has_many   :memberships
  has_many   :notifications, class_name: 'Notification::Base'

  validates_presence_of :account_id
  validates_uniqueness_of :user_id, scope: :account_id, allow_nil: true
  validates_with DuplicateEmployeeValidator, on: :create

  after_create :create_membership

  def self.order_by_names
    order('last_name, first_name')
  end

  def role?(asked)
    role == asked
  end

  Roles.each do |given_role|
    define_method :"#{given_role}?" do
      role?(given_role)
    end

    scope given_role.pluralize.to_sym, where(role: given_role)
  end

  def self.planners_and_owners
    where(role: %w(planner owner))
  end

  def active?
    user && user.confirmed?
  end

  def invited?
    invitation.present?
  end

  attr_writer :duplicates
  def duplicates
    @duplicates || []
  end

  def name
    %Q~#{first_name} #{last_name}~
  end

  def name=(new_name)
    if new_name =~ /^(\w+)\s+(\w.*)$/
      self.first_name = $1
      self.last_name = $2.strip
    end
  end

  def last_and_first_name
    %Q~#{last_name}, #{first_name}~
  end

  # TODO remove when we want fractioned working time
  def weekly_working_time_before_type_cast
    pure = read_attribute(:weekly_working_time)
    pure.blank?? nil : pure.to_i
  end

  def force_create_duplicate?
    force_create_duplicate.in?(['1', 1, true])
  end

  private

  def create_membership
    if organization_id
      memberships.create!(organization_id: organization_id)
    end
  end
end

EmployeeDecorator
