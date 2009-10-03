class User < ActiveRecord::Base
  has_many :memberships
  has_many :accounts, :through => :memberships
end
