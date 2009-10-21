class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.belongs_to :account # temporary - multiple memberships should be possible

      t.string   :email
      t.string   :encrypted_password, :limit => 128
      t.string   :salt,               :limit => 128
      t.string   :confirmation_token, :limit => 128
      t.string   :remember_token,     :limit => 128
      t.boolean  :email_confirmed,    :default => false, :null => false

      t.timestamps
    end

    add_index :users, [:id, :confirmation_token]
    add_index :users, :email#, :unique => true # ?
    add_index :users, :remember_token
  end

  def self.down
    drop_table :users
  end
end
