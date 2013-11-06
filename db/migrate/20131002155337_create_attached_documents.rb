class CreateAttachedDocuments < ActiveRecord::Migration
  def change
    create_table :attached_documents do |t|
      t.string :file
      t.string :name
      t.integer :plan_id

      t.timestamps
    end
  end
end
