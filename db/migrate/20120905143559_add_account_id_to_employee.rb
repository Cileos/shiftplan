class AddAccountIdToEmployee < ActiveRecord::Migration
  def change
    add_column :employees, :account_id, :integer

    add_index :employees, :account_id
  end
end
