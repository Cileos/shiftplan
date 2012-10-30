class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer :organization_id
      t.integer :employee_id
      t.decimal :organization_weekly_working_time

      t.timestamps
    end

    add_index :memberships, :organization_id
    add_index :memberships, :employee_id
  end
end
