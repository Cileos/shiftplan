class CreateRequirements < ActiveRecord::Migration
  def self.up
    create_table :requirements do |t|
      t.integer :workplace_id
      t.datetime :start
      t.datetime :end
      t.integer :quantity

      t.timestamps
    end
  end

  def self.down
    drop_table :requirements
  end
end
