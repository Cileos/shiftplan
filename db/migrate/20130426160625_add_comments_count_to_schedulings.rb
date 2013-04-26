class AddCommentsCountToSchedulings < ActiveRecord::Migration
  def up
    add_column :schedulings, :comments_count, :integer, default: 0, null: false
    execute <<-EOSQL
      UPDATE schedulings SET comments_count = (SELECT COUNT(*) FROM comments WHERE comments.commentable_type = 'Scheduling' AND comments.commentable_id = schedulings.id);
    EOSQL
  end

  def down
    remove_column :schedulings, :comments_count
  end
end
