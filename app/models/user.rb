class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :timeoutable, :lockable, :token_authenticatable, :invitable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :employee_id

  attr_accessor :employee_id

  has_many :employees

  def associate_with_employees
    if employee_id && employee = Employee.find_by_id(employee_id)
      employee.user = self
      employee.save
    end
  end
  after_save :associate_with_employees

  Roles = %w(owner planner)
  serialize :roles, Array

  def roles
    read_attribute(:roles) || []
  end

  def role?(role)
    roles.include?(role.to_s)
  end

  def label
    email
  end

  Roles.each do |role|
    define_method :"#{role}?" do
      role?(role)
    end
  end

  # planner
  has_many :organizations, :foreign_key => 'planner_id'
  def organization
    organizations.first ||
      employees.try(:first).try(:organization) ||
      create_default_organization!
  end

  private
  def create_default_organization!
    roles << 'planner'
    save
    organizations.create! :name => "Organization for #{label}"
  end
end
