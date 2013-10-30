class AttachedDocument < ActiveRecord::Base
  belongs_to :plan
  mount_uploader :file, AttachedDocumentUploader
  attr_accessible :file, :name

  validates_presence_of :file

  before_create :set_name_from_file

  def siblings
    plan.attached_documents
  end

  private

  def set_name_from_file
    if name.blank?
      self.name = file.filename
    end
  end
end
