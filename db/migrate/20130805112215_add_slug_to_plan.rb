class AddSlugToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :slug, :string
    execute %Q~UPDATE plans SET slug = id~
    add_index :plans, :slug, uniq: true
  end
end
