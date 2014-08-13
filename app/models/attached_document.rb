class AttachedDocument < ActiveRecord::Base
  belongs_to :plan
  belongs_to :milestone #optional
  belongs_to :uploader, class_name: 'Employee'
  mount_uploader :file, AttachedDocumentUploader

  validates_presence_of :file
  validate :file, file_size: { maximum: 10.megabyte }

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
