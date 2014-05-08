class RemoveNewNotificationsCountFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :new_notifications_count
  end

  def down
    add_column :users, :new_notifications_count, :integer, default: 0
  end
end
