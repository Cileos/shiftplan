class AddAllDayToSchedulings < ActiveRecord::Migration
  def change
    add_column :schedulings, :all_day, :boolean
  end
end
