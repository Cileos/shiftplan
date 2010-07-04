class AddAccountIdToActivities < ActiveRecord::Migration
  def self.up
    change_table :activities do |t|
      t.belongs_to :account
      t.index :account_id
    end

    if account = Account.first
      Activity.update_all("account_id = #{account.id}")
    end
  end

  def self.down
    change_table :activities do |t|
      t.remove :account_id
      t.remove_index :account_id
    end
  end
end
