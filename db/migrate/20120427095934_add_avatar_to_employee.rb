class AddAvatarToEmployee < ActiveRecord::Migration
  def change
    add_column :employees, :avatar, :string
  end
end
