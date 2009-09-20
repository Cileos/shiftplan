class CreateRequirements < ActiveRecord::Migration
  def self.up
    create_table :requirements do |t|
      t.belongs_to :shift
      t.belongs_to :qualification

      t.timestamps
    end
  end

  def self.down
    drop_table :requirements
  end
end
