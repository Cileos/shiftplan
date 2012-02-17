class AddYearToScheduling < ActiveRecord::Migration
  def change
    add_column :schedulings, :year, :integer
  end
end
