class AddRolesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :roles, :string, :limit => 1024
  end
end
