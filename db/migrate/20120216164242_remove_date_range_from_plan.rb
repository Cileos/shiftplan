class RemoveDateRangeFromPlan < ActiveRecord::Migration
  def up
    remove_column :plans, :first_day
    remove_column :plans, :last_day
  end

  def down
    add_column :plans, :last_day, :date
    add_column :plans, :first_day, :date
  end
end
