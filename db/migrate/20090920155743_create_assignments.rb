class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :assignments do |t|
      t.belongs_to :requirement
      t.belongs_to :employee

      t.timestamps
    end
  end

  def self.down
    drop_table :assignments
  end
end
