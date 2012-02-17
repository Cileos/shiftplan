class AddWeekToScheduling < ActiveRecord::Migration
  def change
    add_column :schedulings, :week, :smallint
  end
end
