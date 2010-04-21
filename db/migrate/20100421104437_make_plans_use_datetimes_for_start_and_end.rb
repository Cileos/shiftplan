class MakePlansUseDatetimesForStartAndEnd < ActiveRecord::Migration
  def self.up
    add_column :plans, :start, :datetime
    add_column :plans, :end, :datetime

    remove_column :plans, :start_date
    remove_column :plans, :end_date
    remove_column :plans, :start_time
    remove_column :plans, :end_time
  end

  def self.down
    add_column :plans, :end_date, :date
    add_column :plans, :start_date, :date
    add_column :plans, :end_time, :time
    add_column :plans, :start_time, :time

    remove_column :plans, :end
    remove_column :plans, :start
  end
end
