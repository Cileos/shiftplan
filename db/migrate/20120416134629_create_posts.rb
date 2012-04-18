class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.belongs_to :blog
      t.string     :title
      t.text       :body
      t.integer    :author_id
      t.datetime   :published_at

      t.timestamps
    end

    add_index :posts, :blog_id
    add_index :posts, :author_id
  end
end
