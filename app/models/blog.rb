class Blog < ActiveRecord::Base
  belongs_to :organization
  has_many :posts, dependent: :destroy

  validates_presence_of :title, :organization
end
