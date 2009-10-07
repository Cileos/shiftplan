class CreateShifts < ActiveRecord::Migration
  def self.up
    create_table :shifts do |t|
      t.belongs_to :plan
      t.belongs_to :workplace

      t.datetime :start
      t.datetime :end
      t.integer  :duration

      t.timestamps
    end
  end

  def self.down
    drop_table :shifts
  end
end
