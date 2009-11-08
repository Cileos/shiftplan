class CreateDefaultAvailabilities < ActiveRecord::Migration
  def self.up
    create_table :default_availabilities do |t|
      t.belongs_to :employee

      t.integer :day_of_week, :limit => 1
      t.time :start, :end

      t.timestamps
    end
  end

  def self.down
    drop_table :default_availabilities
  end
end
