class AddAccountIdsToUnavailability < ActiveRecord::Migration
  def change
    add_column :unavailabilities, :account_ids, :integer, array: true, default: '{}'
  end
end
