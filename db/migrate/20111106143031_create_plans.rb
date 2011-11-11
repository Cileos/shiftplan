class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.belongs_to :organization
      t.string :name
      t.date :first_day
      t.date :last_day

      t.timestamps
    end
    add_index :plans, :organization_id
  end
end
