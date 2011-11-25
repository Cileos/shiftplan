class RenameOrganizationsPlanerIdToPlannerId < ActiveRecord::Migration
  def change
    change_table :organizations do |t|
      t.rename :planer_id, :planner_id
    end
  end
end
