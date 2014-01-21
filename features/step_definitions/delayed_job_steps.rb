When /^all the delayed jobs are invoked$/ do
  Delayed::Job.all.each { |job| job.invoke_job }
end

