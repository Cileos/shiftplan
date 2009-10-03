class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.references :user
      t.references :account
      t.boolean    :admin, :default => false

      t.timestamps
    end

    add_index :memberships, [:user_id, :account_id], :unique => true
  end

  def self.down
    drop_table :memberships
  end
end
