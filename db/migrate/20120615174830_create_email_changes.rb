class CreateEmailChanges < ActiveRecord::Migration
  def change
    create_table :email_changes do |t|
      t.integer :user_id
      t.string  :email
      t.string  :token

      t.timestamps
    end

    add_index :email_changes, :token
  end
end
