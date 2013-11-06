class AddUploaderIdToAttachedDocument < ActiveRecord::Migration
  def change
    add_column :attached_documents, :uploader_id, :integer
    add_index :attached_documents, :uploader_id
  end
end
