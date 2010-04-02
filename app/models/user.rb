class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :registerable, :database_authenticatable, :confirmable, :recoverable,
         :rememberable, :trackable, :validatable, :lockable

  # attr_accessible :name, :email, :password, :password_confirmation

  # ...
  has_many :memberships
  has_many :accounts, :through => :memberships
end
