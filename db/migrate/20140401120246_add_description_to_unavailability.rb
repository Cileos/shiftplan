class AddDescriptionToUnavailability < ActiveRecord::Migration
  def change
    add_column :unavailabilities, :description, :text
  end
end
