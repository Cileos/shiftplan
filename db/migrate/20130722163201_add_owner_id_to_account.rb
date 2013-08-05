class AddOwnerIdToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :owner_id, :integer
    add_index  :accounts, :owner_id
  end
end
