# Restoring from a backup made with the backup-gem
# All WTF may be rooted in this gem
class BackupHelper
  extend FileUtils

  def self.archives_to_skip
    ['config']
  end

  def self.drop_all_tables
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

  def self.restore(location, rails_root, backup_symbol = :app)
    require 'pathname'

    location    = find_backup(location, backup_symbol, ".tar")
    restore_dir = rails_root.join("tmp").join("restore")

    $stdout.sync  = true
    $stderr.sync  = true
    restore_error = false

    puts "Restoring from #{location}"

    puts "  setting up scratch area in #{restore_dir}"
    rm_r  restore_dir if restore_dir.exist?
    mkdir restore_dir

    Dir.chdir(restore_dir) do
      puts "  copying backup into scratch area"
      cp location, "backup.tar"

      puts "  extracting backup collection"
      sh "tar -xf backup.tar"
      puts ""

      puts "Restoring archived folders"
      Dir["**/*.tar.bz2"].each do |fn|
        file = Pathname.new(fn)
        Dir.chdir(file.dirname) do
          archive_name = file.basename(".tar.bz2")

          if archives_to_skip.include? archive_name.to_s
            puts "  skipping #{archive_name}"
            puts ""
          else
            begin
              puts "  unpacking #{file.basename}"
              path = `tar -tPf #{file.basename} | head -n1`.chomp

              # extract only the backupped directory, not the whole structure below
              dirname = path.scan(/^(.*\/)*#{archive_name}/).flatten.first
              dirs = dirname.present? ? dirname.scan('/').size - 1 : 0
              sh "tar --strip-components=#{dirs} -xjPf #{file.basename}"

              src_dir = restore_dir.join(file.dirname).join(archive_name).to_s
              dest_dir = rails_root.join('public/').to_s
              puts "  moving #{src_dir} to #{dest_dir}"
              system("rsync -a #{src_dir} #{dest_dir}")
              rm_rf src_dir
              puts ""
            rescue
              $stderr.puts ""
              $stderr.puts "  ERROR moving #{archive_name} to #{rails_root}/public"
              $stderr.puts "  #{$!.message}"
              $stderr.puts ""
              restore_error = true
            end
          end
        end
      end

      puts "Restoring databases"
      Dir["**/*.sql.bz2"].each do |fn|
        file = Pathname.new(fn)
        Dir.chdir(file.dirname) do
          begin
            puts "  unpacking #{file.basename}"
            sh "bunzip2 #{file.basename}"

            puts "  restoring from sql-file"
            sh "rails db -p < #{restore_dir.join( file.to_s.split('.bz2').first )}"
            puts ""
          rescue
            $stderr.puts ""
            $stderr.puts "  #{$!.message}"
            $stderr.puts ""
            restore_error = true
          end
        end
      end
    end

    if restore_error
      puts "Restore done as far as possible."
    else
      puts "Restore sucessful."
      puts "There may be errors in the database import (you will have seen those)."
    end

    puts "Extracted file are located in #{restore_dir} for further handling."
  end

  protected

  def self.find_backup(location, backup_symbol, suffix)
    suffix.gsub!(/^\./, '')
    cmd = "ls -1 tmp/backup/#{backup_symbol}/*/#{backup_symbol}.#{suffix} | sort | tail -n1"
    location = `#{cmd}`.chomp if location == 'last' || location == 'location'

    Pathname.new(location).expand_path
  end
end
