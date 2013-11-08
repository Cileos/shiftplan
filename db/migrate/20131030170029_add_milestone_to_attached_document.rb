class AddMilestoneToAttachedDocument < ActiveRecord::Migration
  def change
    add_column :attached_documents, :milestone_id, :integer
    add_index :attached_documents, :milestone_id
  end
end
