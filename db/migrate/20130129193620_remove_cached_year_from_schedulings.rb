class RemoveCachedYearFromSchedulings < ActiveRecord::Migration
  def up
    remove_column :schedulings, :year
  end

  def down
    add_column :schedulings, :year, :integer
  end
end
