class CreateEmployeeQualifications < ActiveRecord::Migration
  def change
    create_table :employee_qualifications do |t|
      t.belongs_to :employee
      t.belongs_to :qualification
      t.timestamps
    end

    add_index :employee_qualifications, :employee_id
    add_index :employee_qualifications, :qualification_id
  end
end
