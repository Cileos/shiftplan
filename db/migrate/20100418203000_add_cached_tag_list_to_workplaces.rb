class AddCachedTagListToWorkplaces < ActiveRecord::Migration
  def self.up
    add_column :workplaces, :cached_tag_list, :string
  end

  def self.down
    remove_column :workplaces, :cached_tag_list
  end
end
