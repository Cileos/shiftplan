class AddNextDayReferenceToScheduling < ActiveRecord::Migration
  def change
    add_column :schedulings, :next_day_id, :integer
    add_index :schedulings, :next_day_id
  end
end
