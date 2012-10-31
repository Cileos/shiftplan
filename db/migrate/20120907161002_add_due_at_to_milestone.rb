class AddDueAtToMilestone < ActiveRecord::Migration
  def change
    add_column :milestones, :due_at, :datetime
  end
end
