class AddResponsibleToMilestone < ActiveRecord::Migration
  def change
    add_column :milestones, :responsible_id, :integer
    add_index :milestones, :responsible_id
  end
end
