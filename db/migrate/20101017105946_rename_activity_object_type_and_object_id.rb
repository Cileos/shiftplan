class RenameActivityObjectTypeAndObjectId < ActiveRecord::Migration
  def self.up
    change_table :activities do |t|
      t.rename :object_type, :activity_object_type
      t.rename :object_id, :activity_object_id
    end
  end

  def self.down
    change_table :activities do |t|
      t.rename :activity_object_type, :object_type
      t.rename :activity_object_id, :object_id
    end
  end
end
