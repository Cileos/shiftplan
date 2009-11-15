class AddStartAndEndTimeToPlans < ActiveRecord::Migration
  def self.up
    rename_column :plans, :start, :start_date
    rename_column :plans, :end, :end_date
    add_column :plans, :start_time, :time
    add_column :plans, :end_time, :time

    # Plan.all.each do |plan|
    #   plan.update_attributes!(
    #     :start_time => plan.start_date.to_time,
    #    :end_time => plan.end_date.to_time
    #   )
    # end

    change_column :plans, :start_date, :date
    change_column :plans, :end_date, :date

    remove_column :plans, :duration
  end

  def self.down
  end
end
