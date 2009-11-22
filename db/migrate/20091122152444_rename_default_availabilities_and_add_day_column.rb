class RenameDefaultAvailabilitiesAndAddDayColumn < ActiveRecord::Migration
  def self.up
    rename_table :default_availabilities, :availabilities
    add_column :availabilities, :day, :date
  end

  def self.down
    remove_column :availabilities, :day
    rename_table :availabilities, :default_availabilities
  end
end
