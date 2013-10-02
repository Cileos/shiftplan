class AttachedDocument < ActiveRecord::Base
  belongs_to :plan
  mount_uploader :file, AttachedDocumentUploader
  attr_accessible :file, :name

  validates_presence_of :file
end
