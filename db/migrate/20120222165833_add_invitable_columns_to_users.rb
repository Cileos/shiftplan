class AddInvitableColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invitation_token,       :string
    add_column :users, :invitation_sent_at,     :datetime
    add_column :users, :invitation_accepted_at, :datetime
    add_column :users, :invitation_limit,       :integer
    add_column :users, :invited_by_id,          :integer
    add_column :users, :invited_by_type,        :string

    change_column_null :users, :encrypted_password, true
  end
end
