class AddAccountIdToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :account_id, :integer
    add_index  :invitations, :account_id
  end
end
