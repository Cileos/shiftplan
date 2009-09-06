class CreateWorkplaceRequirements < ActiveRecord::Migration
  def self.up
    create_table :workplace_requirements do |t|
      t.belongs_to :workplace
      t.belongs_to :qualification
      t.integer :quantity

      t.timestamps
    end
  end

  def self.down
    drop_table :workplace_requirements
  end
end
