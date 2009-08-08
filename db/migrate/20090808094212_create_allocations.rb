class CreateAllocations < ActiveRecord::Migration
  def self.up
    create_table :allocations do |t|
      t.references :employee
      t.references :workplace
      t.datetime :start
      t.datetime :end

      t.timestamps
    end
  end

  def self.down
    drop_table :allocations
  end
end
