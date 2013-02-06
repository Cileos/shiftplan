class CreateDemands < ActiveRecord::Migration
  def change
    create_table :demands do |t|
      t.integer :quantity
      t.integer :qualification_id
      t.integer :shift_id

      t.timestamps
    end
    add_index :demands, :qualification_id
    add_index :demands, :shift_id
  end
end
