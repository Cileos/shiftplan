class RemoveOrganizationIdFromQualifications < ActiveRecord::Migration
  def up
    remove_column :qualifications, :organization_id
  end

  def down
    add_column :qualifications, :organization_id, :integer
    add_index  :qualifications, :organization_id
  end
end
