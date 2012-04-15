class RemoveInvitableColumnsFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :invitation_token
    remove_column :users, :invitation_sent_at
    remove_column :users, :invitation_accepted_at
    remove_column :users, :invitation_limit
    remove_column :users, :invited_by_id
    remove_column :users, :invited_by_type
  end

  def down
    add_column :users, :invitation_token,       :string
    add_column :users, :invitation_sent_at,     :datetime
    add_column :users, :invitation_accepted_at, :datetime
    add_column :users, :invitation_limit,       :integer
    add_column :users, :invited_by_id,          :integer
    add_column :users, :invited_by_type,        :string
  end
end
