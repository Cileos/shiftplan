class CreateQualifications < ActiveRecord::Migration
  def change
    create_table :qualifications do |t|
      t.string  :name
      t.integer :organization_id

      t.timestamps
    end

    add_index :qualifications, :organization_id
  end
end
