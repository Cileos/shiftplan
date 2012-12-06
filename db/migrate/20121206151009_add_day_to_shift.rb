class AddDayToShift < ActiveRecord::Migration
  def change
    add_column :shifts, :day, :integer
  end
end
