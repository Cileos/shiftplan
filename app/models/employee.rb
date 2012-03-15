class Employee < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :weekly_working_time

  validates_presence_of :first_name, :last_name
  validates_numericality_of :weekly_working_time, only_integer: true, allow_nil: true, greater_than_or_equal_to: 0

  belongs_to :organization
  belongs_to :user
  has_many :schedulings

  def invited?
    user.present? && user.invited?
  end

  def invitation_accepted?
    user.present? && user.invitation_accepted_at?
  end

  def invitation_sent_at
    user.present? ? user.invitation_sent_at : nil
  end

  def invitation_accepted_at
    user.present? ? user.invitation_accepted_at : nil
  end

  def name
    %Q~#{first_name} #{last_name}~
  end

  def self.order_by_name
    order('last_name ASC, first_name ASC')
  end
end

EmployeeDecorator
