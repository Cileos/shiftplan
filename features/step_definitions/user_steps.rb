After do
  visit "/users/sign_out"
end

Given /^the following users:$/ do |users|
  users.hashes.each do |attributes|
    attributes = attributes.dup
    attributes.delete('name') # because users don't have names ...
    attributes['password_confirmation'] = attributes['password']
    user = User.new(attributes)
    user.skip_confirmation!
    user.save!
  end
end

Given /^I am logged in for "([^\"]*)" with "([^\"]*)" and "([^\"]*)"$/ do |account, email, password|
  account = Account.find_by_name(account)

  # visit "/users/sign_in?account_name=#{account.subdomain}"
  host! "#{account.subdomain}.#{Steam.config[:server_name]}:#{Steam.config[:server_port]}"
  visit "/users/sign_in"
  fill_in 'Email', :with => email
  fill_in 'Password', :with => password
  click_button 'Login'
  response.status.should == 200
end

Given /^I am logged in as "([^\"]*)"$/ do |email|
  user = User.find_by_email(email) || raise("can't find a user with the email address #{email}")
  @browser.request.headers['test.current_user.id'] = user.id
end