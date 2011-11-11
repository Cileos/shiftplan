class Employee < ActiveRecord::Base
  validates_presence_of :first_name, :last_name
  attr_accessible :first_name, :last_name

  def name
    %Q~#{first_name} #{last_name}~
  end

  def self.order_by_name
    order('last_name ASC, first_name ASC')
  end

  belongs_to :organization
end
