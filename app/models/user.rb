class User < ActiveRecord::Base
  include Gravtastic
  gravtastic
  mount_uploader :avatar, AvatarUploader

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :timeoutable, :lockable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email,
                  :password,
                  :password_confirmation,
                  :remember_me,
                  :employee_id,
                  :confirmed_at,
                  :locale,
                  :receive_notification_emails,

                  :first_name,
                  :last_name,
                  :organization_name,
                  :account_name,
                  :confirming_email_change

  attr_reader :current_employee
  attr_reader :current_membership

  # Virtual attributes for registration purposes. On registration the auto-created organization
  # and employee get useful values.
  attr_accessor :first_name,
                :last_name,
                :organization_name,
                :account_name,
                :confirming_email_change

  include Volksplaner::CaseInsensitiveEmailAttribute
  validates :email, :email => true
  validates_inclusion_of :locale, in: lambda { |u| I18n.available_locales.map(&:to_s) }, allow_blank: true

  has_many :employees # but just one employee per account
  has_many :invitations
  has_one  :email_change
  has_many :accounts, through: :employees

  has_many :memberships, :through => :employees
  # organizations the user joined (aka "has a membership in")
  has_many :joined_organizations, :through => :memberships, source: :organization

  has_many :notifications, through: :employees
  has_many :schedulings, through: :employees

  has_many :posts_of_joined_organizations, source: :posts, through: :joined_organizations

  def notifications_for_hub
    notifications.for_hub
  end

  def notifications_for_dashboard
    notifications.for_dashboard
  end

  # unsure about the naming of this method.. rather call it organizations_for_account ?
  def organizations_for(account)
    # a user only has one employee per account but can have several employees across accounts
    employee = employee_for_account(account)
    # If the employee is the/an owner of the account then he should be allowed to see/do things
    # in all the organizations of the account. If the user is no owner, then only list
    # organizations for which he has a membership (has many through membership)
    employee.owner? ? account.organizations : employee.organizations
  end

  def employee_for_account(account)
    employees.find_by_account_id(account.id)
  end

  # A Planner or Owner does not need a membership
  def organizations
    orgs = joined_organizations

    accounts.each do |a|
      e = employee_for_account(a)
      if e.owner?
        orgs += a.organizations
      end
    end
    orgs.uniq
  end

  def label
    email
  end

  def current_employee=(wanted_employee)
    if wanted_employee.nil? || wanted_employee.user == self
      @current_employee = wanted_employee
    else
      raise ArgumentError, "given employee #{wanted_employee} does not belong to #{self}"
    end
  end

  def current_membership=(wanted_membership)
    if wanted_membership.nil? || wanted_membership.employee.user == self
      @current_membership = wanted_membership
    else
      raise ArgumentError, "given membership #{wanted_membership} does not exist for #{self}"
    end
  end

  def find_employee_with_avatar
    employees.order(:created_at).detect { |employee| employee.avatar? }
  end

  # Works at multiple organizations or accounts
  def multiple?
    organizations.count > 1
  end

  def confirmed?
    !confirmed_at.nil?
  end

  def confirming_email_change?
    email_change and confirming_email_change
  end

  def name_or_email
    if multiple?
      email
    else
      employees.first.name
    end
  end

  def apply_email_change
    self.email = email_change.email
  end
  before_validation :apply_email_change, if: :confirming_email_change?

  after_save if: :confirming_email_change? do |user|
    user.email_change.touch(:confirmed_at)
  end

  def create_email_change
    # If the user is just confirming his/her email change by clicking on the
    # confirmation link in the received email we do not want to create a new
    # email change.
    return true if confirming_email_change?
    if email_was.present? and email_changed?
      email_change.destroy if email_change
      create_email_change!(email: email)
      email = email_was
    end
    true
  end
  before_save :create_email_change
end

UserDecorator
