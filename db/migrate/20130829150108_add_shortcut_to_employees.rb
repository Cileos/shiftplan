class AddShortcutToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :shortcut, :string, limit: 4
  end
end
