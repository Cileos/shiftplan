class CreateWorkplaceQualifications < ActiveRecord::Migration
  def self.up
    create_table :workplace_qualifications do |t|
      t.references :workplace
      t.references :qualification
    end
  end

  def self.down
    drop_table :workplace_qualifications
  end
end
