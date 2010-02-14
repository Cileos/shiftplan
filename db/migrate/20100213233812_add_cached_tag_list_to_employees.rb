class AddCachedTagListToEmployees < ActiveRecord::Migration
  def self.up
    add_column :employees, :cached_tag_list, :string
  end

  def self.down
    remove_column :employees, :cached_tag_list
  end
end
