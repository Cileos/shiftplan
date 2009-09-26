class CreateEmployeeQualifications < ActiveRecord::Migration
  def self.up
    create_table :employee_qualifications do |t|
      t.references :employee
      t.references :qualification
    end
  end

  def self.down
    drop_table :employee_qualifications
  end
end
