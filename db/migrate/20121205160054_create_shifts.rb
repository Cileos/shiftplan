class CreateShifts < ActiveRecord::Migration
  def change
    create_table :shifts do |t|
      t.integer  :plan_template_id
      t.time     :starts_at
      t.time     :ends_at
      t.integer  :team_id
      t.integer  :next_day_id
      t.integer  :day

      t.timestamps
    end
    add_index :shifts, :plan_template_id
    add_index :shifts, :team_id
    add_index :shifts, :next_day_id
  end
end
