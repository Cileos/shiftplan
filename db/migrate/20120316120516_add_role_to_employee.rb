class AddRoleToEmployee < ActiveRecord::Migration
  def change
    add_column :employees, :role, :string
  end
end
