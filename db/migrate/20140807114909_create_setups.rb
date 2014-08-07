class CreateSetups < ActiveRecord::Migration
  def change
    create_table :setups do |t|
      t.string :employee_first_name
      t.string :employee_last_name
      t.string :account_name
      t.string :organization_name
      t.string :team_names
      t.references :user

      t.timestamps
    end
  end
end
