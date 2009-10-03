class Account < ActiveRecord::Base
  has_many :memberships
  has_many :users, :through => :memberships

  validates_presence_of :name

  def admin=(attributes)
    memberships.build(:user => User.new(attributes.merge(:email_confirmed => true)), :admin => true) if new_record?
  end
end
