namespace :db do
  desc "Cleans the db and seeds from the latest backup. (staging only)"
  task :seed_from_backup => [:only_on_staging, :environment] do
    latest = `find ~backups/volksplaner/ -name 'clockwork_production*.sql.gz' | sort | tail -n 1`.chomp
    Rake::Task['db:drop_all_tables'].invoke &&
    system("gunzip -c '#{latest}' | script/restore production") &&
    Rake::Task['db:migrate'].invoke
  end

  desc "Drops all the tables in the current database. Good alternative to db:drop if the database is still used by other processes"
  task :drop_all_tables => :environment do
    # Select all tables that are application (public) tables and not views
    sql = <<-SQL
      SELECT table_name
      FROM information_schema.tables
      WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
      ORDER BY table_name;
    SQL
    table_names = ActiveRecord::Base.connection.execute(sql).map {|t| t['table_name']}

    table_names.each do |table_name|
      sql = "DROP TABLE IF EXISTS #{table_name} CASCADE"
      ActiveRecord::Base.connection.execute(sql)
      puts "Table #{table_name} has been dropped"
    end
  end
end
