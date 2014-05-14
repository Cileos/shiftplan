# basically a revert of db/migrate/20140402143757_add_account_ids_to_unavailability.rb
class RemoveAccountIdsFromUnavailability < ActiveRecord::Migration
  def up
    remove_column :unavailabilities, :account_ids
  end

  def down
    add_column :unavailabilities, :account_ids, :integer, array: true, default: '{}'
  end
end
