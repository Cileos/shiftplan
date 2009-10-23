Given /^the following users:$/ do |users|
  users.hashes.each do |attributes|
    attributes = attributes.dup
    attributes.delete('name') # because users don't have names ...
    attributes['password_confirmation'] = attributes['password']
    attributes['email_confirmed'] = true
    User.create!(attributes)
  end
end

Given /^I am logged in with "([^\"]*)" and "([^\"]*)"$/ do |email, password|
  visit '/session/new'
  fill_in 'E-Mail', :with => email
  fill_in 'Password', :with => password
  click_button 'Login'
  response.status.should == 200
end
