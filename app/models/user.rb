class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :timeoutable, :lockable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  Roles = %w(planer)
  serialize :roles, Array

  def roles
    read_attribute(:roles) || []
  end

  def role?(role)
    roles.include?(role.to_s)
  end

  Roles.each do |role|
    define_method :"is_#{role}?" do
      role?(role)
    end
  end

  # planer
  has_many :organizations, :foreign_key => 'planer_id'
  def organization
    organizations.first
  end
end
