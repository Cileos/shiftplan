class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.integer :milestone_id
      t.datetime :due_at
      t.boolean :done

      t.timestamps
    end

    add_index :tasks, :milestone_id
  end
end
