class Employee < ActiveRecord::Base
  Roles = %w(owner planner)

  attr_accessible :first_name, :last_name, :weekly_working_time

  validates_presence_of :first_name
  validates_numericality_of :weekly_working_time, allow_nil: true, greater_than_or_equal_to: 0
  validates_inclusion_of :role, in: Roles, allow_blank: true

  belongs_to :organization
  belongs_to :user
  has_many :schedulings
  has_one :invitation
  has_many :posts, foreign_key: :author_id
  has_many :comments

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

  def self.order_by_name
    order('last_name ASC, first_name ASC')
  end
end

EmployeeDecorator
