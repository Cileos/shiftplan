class AddOrganizationIdToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :organization_id, :integer
    add_index :employees, :organization_id
  end
end
