namespace :service do
  task :run, [:service_name] do |t,args|
    service_name = args.service_name
    STDERR.puts "Running service #{service_name}"
    service_name.constantize.new.run
  end

  task :run => :environment
end
