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
    :first_name, :last_name, :organization_name, :on_signup, :confirming_email_change
  attr_reader :current_employee
  # Virtual attributes for registration purposes. On registration the auto-created organization
  # and employee get useful values.
  attr_accessor :first_name, :last_name, :organization_name, :on_signup, :confirming_email_change

  validates_presence_of :first_name, :last_name, :organization_name, if: Proc.new { |u| u.on_signup }

  has_one  :owned_account, foreign_key: 'owner_id', class_name: "Account"
  has_many :employees
  has_many :invitations
  has_many :organizations, :through => :employees
  has_one  :email_change

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

  def has_multiple_employees?
    employees.count > 1
  end

  def confirming_email_change?
    email_change and confirming_email_change
  end

  def name_or_email
    if has_multiple_employees?
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
<<<<<<< HEAD
=======

  def setup
    unless new_record?
      if organizations.empty? && organization_name.present?
        Organization.create!(name: organization_name).tap do |organization|
          organization.setup
          employees.create! do |e|
            e.first_name = first_name
            e.last_name  = last_name
            e.organization = organization
            e.role = 'owner'
          end
        end
      end

      account = owned_account
      employees.where(role: 'owner').each do |employee|
        if employee.organization.account.blank?
          account ||= Account.create! owner: self
          employee.organization.account = account
          employee.organization.save!
        end
      end
      organizations.where(account_id: nil).each do |organization|
      end
    end
  end
>>>>>>> f341d1a... squash company blog
end
