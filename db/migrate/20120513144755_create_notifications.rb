class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string   :type
      t.string   :notifiable_object_type
      t.integer  :notifiable_object_id
      t.integer  :employee_id

      t.timestamps
    end

    add_index :notifications, :employee_id
    add_index :notifications, :notifiable_object_id
  end
end
