class Employee < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader

  Roles = %w(owner planner)

  attr_accessible :first_name, :last_name, :weekly_working_time, :avatar, :avatar_cache

  validates_presence_of :first_name, :last_name
  validates_numericality_of :weekly_working_time, allow_nil: true, greater_than_or_equal_to: 0
  validates_inclusion_of :role, in: Roles, allow_blank: true

  belongs_to :organization
  belongs_to :user
  has_many :schedulings
  has_one :invitation
  has_many :posts, foreign_key: :author_id
  has_many :comments

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
    pure = read_attribute(:weekly_working_time)
    pure.blank?? nil : pure.to_i
  end
end

EmployeeDecorator
