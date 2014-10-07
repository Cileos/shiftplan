class JoinOvernightables < ActiveRecord::Migration
  def up
    OvernightableJoiner.new.run!
  end
end
