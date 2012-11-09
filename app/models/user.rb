class User < ActiveRecord::Base
  include Gravtastic
  gravtastic

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :timeoutable, :lockable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :employee_id, :confirmed_at,
    :first_name, :last_name, :organization_name, :account_name, :on_signup, :confirming_email_change
  attr_reader :current_employee
  # Virtual attributes for registration purposes. On registration the auto-created organization
  # and employee get useful values.
  attr_accessor :first_name, :last_name, :organization_name, :account_name, :on_signup, :confirming_email_change

  validates_presence_of :first_name, :last_name, :organization_name, :account_name, if: Proc.new { |u| u.on_signup }

  has_many :employees # but just one employee per account
  has_many :invitations
  has_one  :email_change
  has_many :accounts, through: :employees

  has_many :memberships, :through => :employees
  # organizations the user joined (aka "has a membership in")
  has_many :joined_organizations, :through => :memberships, source: :organization

  has_many :notifications, through: :employees

  # unsure about the naming of this method.. rather call it organizations_for_account ?
  def organizations_for(account)
    # a user only has one employee per account but can have several employees across accounts
    employee = employee_for_account(account)
    # If the employee is the/an owner of the account then he should be allowed to see/do things
    # in all the organizations of the account. If the user is no owner, then only list
    # organizations for which he has a membership (has many through membership)
    employee.owner? || employee.planner? ? account.organizations : employee.organizations
  end

  def employee_for_account(account)
    employees.find_by_account_id!(account.id)
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

  def find_employee_with_avatar
    employees.order(:created_at).detect { |employee| employee.avatar? }
  end

  # Works at multiple organizations or accounts
  def is_multiple?
    joined_organizations.count > 1
  end

  def confirming_email_change?
    email_change and confirming_email_change
  end

  def name_or_email
    if is_multiple?
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

  # This method gets called on successful signup. It was successful, if
  # the user got saved (persisted?) and we know, we are in signup mode if the
  # virtual attribute 'on_signup' is set on the user model. 'on_signup' is a
  # hidden field in the registration form.
  #
  # If called on successful signup, an account, an organization, an employee with role
  # "owner" (the account owner) which belongs the just created user and an
  # organization blog get created here.
  def setup
    if persisted? and on_signup
      # The account_name is a virtual attribute of the user model and needs to
      # be entered by the registering user in the signup form.
      Account.create!(:name => account_name).tap do |account|
        # The organization_name is a virtual attribute of the user model and needs to
        # be entered by the registering user in the signup form.
        organization = Organization.create!(:name => organization_name, :account => account)
        organization.setup # creates the organization's blog
        employees.create! do |e|
          e.first_name  = first_name
          e.last_name   = last_name
          e.account     = account
          e.role        = 'owner'
        end
      end
    end
  end
end

UserDecorator
