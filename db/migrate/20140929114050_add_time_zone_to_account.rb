class AddTimeZoneToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :time_zone_name, :string, limit: 32
  end
end
