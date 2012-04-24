class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :timeoutable, :lockable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :employee_id, :confirmed_at,
    :first_name, :last_name, :organization_name
  attr_reader :current_employee
  # Virtual attributes for registration purposes. On registration the auto-created organization
  # and employee get useful values.
  attr_accessor :first_name, :last_name, :organization_name

  has_many :employees
  has_many :invitations
  has_many :organizations, :through => :employees

  def label
    email
  end

  def current_employee=(wanted_employee)
    if wanted_employee.user == self
      @current_employee = wanted_employee
    else
      raise ArgumentError, "given employee #{wanted_employee} does not belong to #{self}"
    end
  end
end
