class CreateShifts < ActiveRecord::Migration
  def change
    create_table :shifts do |t|
      t.integer  :plan_template_id
      t.datetime :starts_at
      t.datetime :ends_at
      t.integer  :team_id

      t.timestamps
    end
    add_index :shifts, :plan_template_id
    add_index :shifts, :team_id
  end
end
