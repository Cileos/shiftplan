class AddSlugToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :slug, :string
    execute %Q~UPDATE accounts SET slug = id~
    add_index :accounts, :slug, unique: true
  end
end
