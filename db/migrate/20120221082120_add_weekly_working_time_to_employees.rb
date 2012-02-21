class AddWeeklyWorkingTimeToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :weekly_working_time, :decimal
  end
end
