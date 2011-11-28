class CreateSchedulings < ActiveRecord::Migration
  def change
    create_table :schedulings do |t|
      t.belongs_to :plan
      t.belongs_to :employee
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
    add_index :schedulings, :plan_id
    add_index :schedulings, :employee_id
  end
end
