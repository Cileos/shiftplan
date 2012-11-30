class RemoveAccountIdFromInvitation < ActiveRecord::Migration
  def up
    remove_column :invitations, :account_id
  end

  def down
    add_column :invitations, :account_id, :integer
    add_index  :invitations, :account_id
  end
end
