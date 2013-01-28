class AddDescriptionToMilestone < ActiveRecord::Migration
  def change
    add_column :milestones, :description, :text

  end
end
