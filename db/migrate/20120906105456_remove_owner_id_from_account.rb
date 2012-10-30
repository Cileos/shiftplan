class RemoveOwnerIdFromAccount < ActiveRecord::Migration
  def up
    remove_column :accounts, :owner_id
  end

  def down
    add_column :accounts, :owner_id, :integer
    add_index :accounts, :owner_id
  end
end
