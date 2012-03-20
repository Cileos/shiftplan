class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :timeoutable, :lockable, :token_authenticatable, :invitable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :employee_id
  attr_accessor :employee_id
  attr_reader :current_employee

  has_many :employees
  has_many :organizations, :through => :employees

  after_save :associate_with_employees

  def associate_with_employees
    if employee_id && employee = Employee.find_by_id(employee_id)
      employee.user = self
      employee.save!
    end
  end

  def label
    email
  end

  def employee
    Employee.find_by_id(employee_id)
  end

  def current_employee=(wanted_employee)
    if wanted_employee.user == self
      @current_employee = wanted_employee
    else
      raise ArgumentError, "given employee #{wanted_employee} does not belong to #{self}"
    end
  end
end

UserDecorator
