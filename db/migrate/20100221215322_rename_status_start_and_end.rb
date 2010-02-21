class RenameStatusStartAndEnd < ActiveRecord::Migration
  def self.up
    rename_column :statuses, :start, :start_time
    rename_column :statuses, :end,   :end_time
  end

  def self.down
    rename_column :statuses, :end_time,   :end
    rename_column :statuses, :start_time, :start
  end
end
