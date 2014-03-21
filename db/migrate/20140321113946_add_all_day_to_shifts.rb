class AddAllDayToShifts < ActiveRecord::Migration
  def change
    add_column :shifts, :all_day, :boolean
  end
end
