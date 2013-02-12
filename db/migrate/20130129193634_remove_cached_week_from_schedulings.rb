class RemoveCachedWeekFromSchedulings < ActiveRecord::Migration
  def up
    remove_column :schedulings, :week
  end

  def down
    add_column :schedulings, :week, :integer, limit: 2
  end
end
