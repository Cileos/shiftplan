class CreateShifts < ActiveRecord::Migration
  def change
    create_table :shifts do |t|
      t.integer :plan_template_id
      t.integer :start_hour
      t.integer :end_hour
      t.integer :start_minute
      t.integer :end_minute
      t.integer :team_id

      t.timestamps
    end
    add_index :shifts, :plan_template_id
    add_index :shifts, :team_id
  end
end
