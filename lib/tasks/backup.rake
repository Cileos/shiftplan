namespace :backup do
  ## UTILITIES

  # find and store the application-config and the backup-symbol specifically
  # undocumented to keep it "private"
  task :backup_symbol do
    @backup_symbol = "clockwork"
  end

  # find and store the rails-root.
  # undocumented to keep it "private"
  task :rails_root do
    @rails_root ||= begin
                      require 'rails/version'
                      if Rails::VERSION::STRING != '3.2.13'
                        $stderr.puts "Unexpected Rails-version, invoking environment just to be sure"
                        Rake::Task[:environment].invoke
                        Rails.root
                      else
                        require 'rails/engine'
                        Rails::Engine.send(:new).send(:find_root_with_flag, "config.ru", Dir.pwd)
                      end
                    end
  end

  # load the backup-helper
  # undocumented to keep it "private"
  task :backup_helper do
    require_relative '../backup_helper'
  end

  ## MAIN BACKUP METHODS

  desc "List locally available backups"
  task :list => [:backup_symbol] do
    system "ls -hal tmp/backup/#{@backup_symbol} tmp/backup.tar tmp/backup.tar.gpg 2>/dev/null"
  end

  desc "Restore the application from 'tmp/backup.tar', which is downloaded if necessary, migrating afterwards"
  task :restore => [:'tmp/backup.tar', :drop_all_tables, :load, :'db:migrate']

  desc "Restore from a backup, cleaning up afterwards"
  task :restore_clean => [:restore, :clean_files]

  ## END OF MAIN METHODS


  # on servers, backup is directly accessible per ftp.
  # On dev machines, we have to ssh into server first
  def backup_ftp(lftp_command, rest='')
    binary = '/usr/local/bin/backup_ftp'
    command = "#{binary} '#{lftp_command}' #{rest}"
    if File.exist?(binary)
      command
    else
      server = 'application@gruetz.clockwork.io'
      %Q{ssh #{server} "#{command}"}
    end
  end

  desc "Download 'tmp/backup.tar.gpg' from backup-server"
  task :download => [:backup_symbol, :rails_root] do
    find_latest = backup_ftp("ls ~/backups/clockwork/*/*.gpg", " | sed -r 's_^.*\s__' | sort | tail -n1")
    latest = %x{#{find_latest}}.chomp

    target = @rails_root.join("tmp", "backup.tar.gpg")

    puts "Latest remote backup location is: #{latest}"
    puts "Downloading backup to: #{target}"

    get = backup_ftp("cat #{latest}")
    sh %Q~#{get} > #{target}~
  end

  desc "Ensure that a file 'tmp/backup.tar' is present, downloading and decrypting one if necessary"
  file :'tmp/backup.tar' => [:'tmp/backup.tar.gpg'] do |t|
    # do not ever ask for anything when restoring backup from cron on the servers
    noask = `hostname -f`.include?('clockwork.io') ? ' --no-tty --batch ' : ''
    sh %Q~gpg --use-agent #{noask} -o '#{t.name}' -d '#{t.prerequisites.first}'~
  end

  desc "Ensure that a file 'tmp/backup.tar.gpg' is present, downloading one if necessary"
  file :'tmp/backup.tar.gpg' do
    # this is not a prerequisite, it's how this file is "created". Therefore we
    # have it in the body that is not executed if we have a backup present
    Rake::Task[:'backup:download'].invoke
  end

  desc "Drop all tables (to have a clean database and prevent duplicate pk values after/during restore)"
  task :drop_all_tables => [:environment, :backup_helper] do
    BackupHelper.drop_all_tables
  end

  desc "Load schema and data the from 'tmp/backup.tar'"
  task :load => [:rails_root, :backup_symbol, :backup_helper] do |t|
    BackupHelper.restore('tmp/backup.tar', @rails_root, @backup_symbol)
  end

  desc "Clean intermediate files"
  task :clean_files do
    ['tmp/backup.tar.gpg', 'tmp/backup.tar'].each do |fn|
      sh "rm -f #{fn}" if File.exists?(fn)
    end
    ['tmp/restore'].each do |fn|
      sh "rm -rf #{fn}" if File.exists?(fn)
    end
  end

end
