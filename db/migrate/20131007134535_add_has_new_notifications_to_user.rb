class AddHasNewNotificationsToUser < ActiveRecord::Migration
  def change
    add_column :users, :has_new_notifications, :boolean, default: false
  end
end
