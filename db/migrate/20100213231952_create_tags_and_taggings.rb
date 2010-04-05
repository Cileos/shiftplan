class CreateTagsAndTaggings < ActiveRecord::Migration
  def self.up
    create_table :taggings, :force => true do |t|
      t.integer  :tag_id
      t.integer  :taggable_id
      t.string   :taggable_type
      t.timestamps
    end

    add_index :taggings, [:tag_id]
    add_index :taggings, [:taggable_id, :taggable_type]

    create_table :tags, :force => true do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :tags
    drop_table :taggings
  end
end
