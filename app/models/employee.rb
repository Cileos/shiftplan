class Employee < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader

  Roles = %w(owner planner)

  attr_accessible :first_name, :last_name, :weekly_working_time, :avatar, :avatar_cache, :organization_id, :account_id
  attr_accessor :organization_id

  validates_presence_of :first_name, :last_name, :account_id
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
  end

  def active?
    invitation.try(:accepted?) || planner? || owner?
  end

  def invited?
    invitation.present?
  end

  def name
    %Q~#{first_name} #{last_name}~
  end

  def last_and_first_name
    %Q~#{last_name}, #{first_name}~
  end

  # TODO remove when we want fractioned working time
  def weekly_working_time_before_type_cast
    read_attribute(:weekly_working_time).to_i
  end

  private

  def create_membership
    if organization_id
      memberships.create!(organization_id: organization_id)
    end
  end
end

EmployeeDecorator
