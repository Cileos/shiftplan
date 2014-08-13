When /^all the delayed jobs are invoked$/ do
  Delayed::Worker.new.work_off
end

