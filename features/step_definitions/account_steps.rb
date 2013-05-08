When /^I follow "(.*?)" for #{capture_model}$/ do |link_text, account_name|
  account = model!(account_name)
  within "#account_#{account.id}" do
    step %~I follow "#{link_text}"~
  end
end
