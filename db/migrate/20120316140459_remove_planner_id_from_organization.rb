class RemovePlannerIdFromOrganization < ActiveRecord::Migration
  def up
    remove_column :organizations, :planner_id
  end

  def down
    add_column :organizations, :planner_id, :integer
  end
end
