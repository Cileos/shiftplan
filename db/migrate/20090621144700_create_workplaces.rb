class CreateWorkplaces < ActiveRecord::Migration
  def self.up
    create_table :workplaces do |t|
      t.string :name
      t.string :color, :limit => 6

      t.timestamps
    end
  end

  def self.down
    drop_table :workplaces
  end
end
