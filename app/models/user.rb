class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :timeoutable, :lockable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  Roles = %w(planner)
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
    define_method :"is_#{role}?" do
      role?(role)
    end
  end

  # planner
  has_many :organizations, :foreign_key => 'planner_id'
  def organization
    organizations.first || create_default_organization!
  end

  private
  def create_default_organization!
    organizations.create! :name => "Organization for #{label}"
  end

end
