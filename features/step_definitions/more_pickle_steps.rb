Given /^#{capture_model} was scheduled in #{capture_model} as following:$/ do |employee, plan, table|
  employee = model!(employee)
  plan     = model!(plan)
  table.hashes.each do |line|
    Factory(:scheduling, {plan: plan, employee: employee, year: nil, week: nil, starts_at: nil, ends_at: nil, date: nil}.merge(line))
  end
end
