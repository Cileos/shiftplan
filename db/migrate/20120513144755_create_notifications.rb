class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string   :type,            null: false
      t.string   :notifiable_type
      t.integer  :notifiable_id
      t.integer  :employee_id,     null: false
      t.datetime :sent_at

      t.timestamps
    end

    add_index :notifications, :employee_id
    add_index :notifications, :notifiable_id
  end
end
