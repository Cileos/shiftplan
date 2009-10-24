class Account < ActiveRecord::Base
  has_many :memberships
  has_many :users, :through => :memberships

  has_many :employees
  has_many :workplaces
  has_many :qualifications
  has_many :plans

  validates_presence_of :name

  def admin=(attributes)
    memberships.build(
      :account => self,
      :user => User.new(attributes.merge(:email_confirmed => true)),
      :admin => true
    ) if new_record?
  end
end
