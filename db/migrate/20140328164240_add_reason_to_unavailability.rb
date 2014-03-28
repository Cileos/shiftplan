class AddReasonToUnavailability < ActiveRecord::Migration
  def change
    add_column :unavailabilities, :reason, :string, limit: 32
  end
end
