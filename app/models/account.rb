class Account < ActiveRecord::Base
  has_many :memberships
  has_many :users, :through => :memberships

  has_many :employees
  has_many :workplaces
  has_many :qualifications
  has_many :plans

  validates_presence_of :name

  def admin=(attributes)
    user = User.create!(attributes)
    user.confirm!

    memberships.build(
      :account => self,
      :user => user,
      :admin => true
    ) if new_record?
  end
end
