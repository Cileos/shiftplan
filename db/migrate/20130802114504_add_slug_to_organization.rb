class AddSlugToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :slug, :string
    execute %Q~UPDATE organizations SET slug = id~
    add_index :organizations, :slug, uniq: true
  end
end
