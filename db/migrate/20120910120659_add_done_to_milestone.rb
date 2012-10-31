class AddDoneToMilestone < ActiveRecord::Migration
  def change
    add_column :milestones, :done, :boolean

  end
end
