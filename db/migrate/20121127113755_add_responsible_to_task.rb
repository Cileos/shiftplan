class AddResponsibleToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :responsible_id, :integer
    add_index :tasks, :responsible_id
  end
end
