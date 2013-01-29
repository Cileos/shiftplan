class AddOvernightMateIdToShifts < ActiveRecord::Migration
  def change
    add_column :shifts, :overnight_mate_id, :integer
    add_index :shifts, :overnight_mate_id
  end
end
