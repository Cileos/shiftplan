class CreateDemandsShifts < ActiveRecord::Migration
  def change
    create_table :demands_shifts do |t|
      t.integer :demand_id
      t.integer :shift_id

      t.timestamps
    end
    add_index :demands_shifts, :demand_id
    add_index :demands_shifts, :shift_id
  end
end
