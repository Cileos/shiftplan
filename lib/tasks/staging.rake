desc 'depend on this task to make sure it can only be run on staging'
task :only_on_staging do
  host = `hostname -f`.chomp
  host =~ /^plock\./ || raise("can run this only on the staging server, but not here: #{host}")
end
