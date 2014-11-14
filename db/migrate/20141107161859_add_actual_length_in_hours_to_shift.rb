class AddActualLengthInHoursToShift < ActiveRecord::Migration
  def change
    # 12.456
    add_column :shifts, :actual_length_in_hours, :decimal, precision: 5, scale: 3
  end
end
