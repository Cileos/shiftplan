class Account < ActiveRecord::Base
  has_many :organizations
  has_many :employees
  has_many :users, through: :employees
end
