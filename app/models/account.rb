class Account < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  has_many :organizations

  validates_presence_of :owner
end
