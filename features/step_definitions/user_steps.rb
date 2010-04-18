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

Given /^I am logged in with "([^\"]*)" and "([^\"]*)"$/ do |email, password|
  visit '/users/sign_in'
  fill_in 'Email', :with => email
  fill_in 'Password', :with => password
  click_button 'Login'
  response.status.should == 200
end

Given /^I am logged in as "([^\"]*)"$/ do |email|
  user = User.find_by_email(email)
  @browser.request.headers['test.current_user.id'] = user.id
end