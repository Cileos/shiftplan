class AddAllDayToUnavailability < ActiveRecord::Migration
  def change
    add_column :unavailabilities, :all_day, :boolean
  end
end
