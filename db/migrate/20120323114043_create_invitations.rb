class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string   :token
      t.datetime :sent_at
      t.datetime :accepted_at
      t.integer  :inviter_id
      t.integer  :organization_id
      t.integer  :employee_id
      t.integer  :user_id

      t.timestamps
    end

    add_index :invitations, :organization_id
    add_index :invitations, :employee_id
    add_index :invitations, :user_id
    add_index :invitations, :inviter_id
  end
end
