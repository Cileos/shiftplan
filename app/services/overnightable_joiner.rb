class OvernightableJoiner
  def run!(options={})
    model = options.fetch(:model) { Scheduling }

    model.transaction do
      %w(schedulings shifts).each do |table|
        model.connection.execute <<-EOSQL
        UPDATE #{table}
        SET ends_at = (
          SELECT nexts.ends_at
          FROM #{table} nexts
          WHERE nexts.id = #{table}.next_day_id
          LIMIT 1
        )
        WHERE next_day_id IS NOT NULL;

        DELETE FROM #{table}
        WHERE id IN (
          SELECT next_day_id
          FROM #{table} firsts
          WHERE firsts.next_day_id IS NOT NULL
        );
        EOSQL
      end
    end

  end
end
