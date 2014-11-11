class AddCancelableToSetup < ActiveRecord::Migration
  def change
    add_column :setups, :cancelable, :boolean
  end
end
