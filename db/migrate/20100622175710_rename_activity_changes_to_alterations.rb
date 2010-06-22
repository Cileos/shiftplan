class RenameActivityChangesToAlterations < ActiveRecord::Migration
  def self.up
    rename_column :activities, :changes, :alterations
  end

  def self.down
    rename_column :activities, :alterations, :changes
  end
end
