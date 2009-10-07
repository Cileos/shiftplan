class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
