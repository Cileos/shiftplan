class AddEmailToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :email, :string
    add_index :invitations, :email
  end
end
