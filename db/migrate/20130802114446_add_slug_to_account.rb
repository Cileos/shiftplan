class AddSlugToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :slug, :string
    execute %Q~UPDATE accounts SET slug = id~
    add_index :accounts, :slug, uniq: true
  end
end
