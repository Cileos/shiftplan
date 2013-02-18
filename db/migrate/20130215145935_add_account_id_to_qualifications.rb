class AddAccountIdToQualifications < ActiveRecord::Migration
  def change
    add_column :qualifications, :account_id, :integer
    add_index  :qualifications, :account_id
  end
end
