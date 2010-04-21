class SerializeEmployeeTokens < ActiveRecord::Migration
  def self.up
    add_column :employees, :token, :string
  end

  def self.down
    remove_column :employees, :token
  end
end
