class DeleteLocations < ActiveRecord::Migration
  def self.up
    remove_column :workplaces, :location_id
    drop_table :locations
  end

  def self.down
    create_table :locations do |t|
      t.belongs_to :account
      t.string :name
      t.timestamps
    end
  end
end
