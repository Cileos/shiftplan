class AddSuspendedToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :suspended, :boolean
  end
end
