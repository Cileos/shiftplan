class CreateUnavailabilities < ActiveRecord::Migration
  def change
    create_table :unavailabilities do |t|
      t.datetime :starts_at
      t.datetime :ends_at
      t.integer :employee_id
      t.integer :user_id

      t.timestamps
    end

    add_index :unavailabilities, :employee_id
    add_index :unavailabilities, :user_id
  end
end
