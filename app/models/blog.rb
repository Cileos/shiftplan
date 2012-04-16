class Blog < ActiveRecord::Base
  belongs_to :organization
  has_many :posts

  validates_presence_of :title, :organization
end