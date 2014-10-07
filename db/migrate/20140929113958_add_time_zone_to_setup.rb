class AddTimeZoneToSetup < ActiveRecord::Migration
  def change
    add_column :setups, :time_zone_name, :string, limit: 32
  end
end
