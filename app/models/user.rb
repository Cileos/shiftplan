class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :registerable, :database_authenticatable, :confirmable, :recoverable,
         :rememberable, :trackable, :validatable, :lockable

  # FIXME: activate this!!!!!
  # attr_accessible :name, :email, :password, :password_confirmation

  # ...
  has_many :memberships
  has_many :accounts, :through => :memberships

  class << self
    def find_for_authentication(conditions)
      account = Account.find_by_subdomain(conditions.delete(:subdomain))
      return unless account
      account.users.where(conditions).first
    end
  end

  def member_of?(account)
    account.user_ids.include?(id)
  end
end
