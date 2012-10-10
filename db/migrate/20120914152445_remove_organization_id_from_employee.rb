class RemoveOrganizationIdFromEmployee < ActiveRecord::Migration
  def up
    remove_column :employees, :organization_id
  end

  def down
    add_column :employees, :organization_id, :integers

    add_index :employees, :organization_id
  end
end
