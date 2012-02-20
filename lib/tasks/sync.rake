namespace :db do
  namespace :sync do
    task :schedulings => :environment do
      STDERR.print "syncing Schedulings... "
      Scheduling.sync! && STDERR.puts("done.")
    end
  end

  task :sync => %w(sync:schedulings)
end
