class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.belongs_to :organization
      t.string     :title

      t.timestamps
    end

    add_index :blogs, :organization_id
  end
end
