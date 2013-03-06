class CreatePlanTemplates < ActiveRecord::Migration
  def change
    create_table :plan_templates do |t|
      t.string  :name
      t.string  :template_type
      t.integer :organization_id

      t.timestamps
    end

    add_index :plan_templates, :organization_id
  end
end
