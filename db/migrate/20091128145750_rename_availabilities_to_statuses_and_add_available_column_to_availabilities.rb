class RenameAvailabilitiesToStatusesAndAddAvailableColumnToAvailabilities < ActiveRecord::Migration
  def self.up
    rename_table :availabilities, :statuses
    add_column :statuses, :status, :string, :limit => 20
  end

  def self.down
    remove_column :statuses, :status
    rename_table :statuses, :availabilities
  end
end
