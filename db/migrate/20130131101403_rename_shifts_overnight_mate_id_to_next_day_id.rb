class RenameShiftsOvernightMateIdToNextDayId < ActiveRecord::Migration
  def up
    rename_column :shifts, :overnight_mate_id, :next_day_id
    rename_index  :shifts, 'index_shifts_on_overnight_mate_id', 'index_shifts_on_next_day_id'
  end

  def down
    rename_column :shifts, :next_day_id, :overnight_mate_id
    rename_index  :shifts, 'index_shifts_on_next_day_id', 'index_shifts_on_overnight_mate_id'
  end
end
