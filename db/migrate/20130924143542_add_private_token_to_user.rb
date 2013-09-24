class AddPrivateTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :private_token, :string, limit: 20
  end
end
