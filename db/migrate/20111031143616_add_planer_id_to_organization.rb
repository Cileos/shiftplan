class AddPlanerIdToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :planer_id, :integer
    add_index :organizations, :planer_id
  end
end
