Given /^#{capture_model} was scheduled in #{capture_model} as following:$/ do |employee, plan, table|
  employee = model!(employee)
  plan     = model!(plan)
  table.hashes.each do |line|
    FactoryGirl.create(:scheduling, {plan: plan, employee: employee, starts_at: nil, ends_at: nil, date: nil}.merge(line))
  end
end

Given /^#{capture_model} is one of #{capture_model}'s (\w+)/ do |subject, owner, association|
  subject = model!(subject)
  owner   = model!(owner)
  owner.send(association) << subject
end

When /^I reload #{capture_model}$/ do |model|
  model!(model).reload
end

Then /^#{capture_model} (should|should not) be done/ do |subject, should_not_not|
  model!(subject).reload.send( should_not_not.sub(' ', '_'), be_done )
end

# Given the employee "Homer" is a member in the organization "Simpson Family"
Given /^#{capture_model} is a (member|planner) (?:of|in) #{capture_model}$/ do |employee, role, organization|
  employee = model! employee
  organization = model! organization

  Membership.create!(
    employee: employee,
    organization: organization,
    role: (role == 'planner' ? 'planner' : nil)
  )
end

# Given the confirmed user "Homer" has joined another account
Given /^#{capture_model} has joined another account(?: with #{capture_fields})?$/ do |user, options|
  user = model! user
  user.should be_a(User)

  options = parse_fields(options)

  expect(lambda {
    account_attrs = {}
    account_attrs[:name] = options['name'] if options['name']
    account = FactoryGirl.create :account, account_attrs
    if organization_name = options['organization_name']
      organization = FactoryGirl.create :organization, account: account, name: organization_name
    else
      organization = FactoryGirl.create :organization, account: account
    end
    if as = options['as']
      employee     = FactoryGirl.create :employee, user: user, account: account, name: as
    else
      employee     = FactoryGirl.create :employee, user: user, account: account
    end
    membership   = FactoryGirl.create :membership, employee: employee, organization: organization
  }).to change(Account, :count).by(1)
end

# Given the employee "Homer" has joined another organization of the account "fukushima"
Given /^#{capture_model} has joined another organization of #{capture_model}$/ do |employee, account|
  employee = model! employee
  employee.should be_a(Employee)

  account = model! account
  account.should be_an(Account)

  expect(lambda {
    organization = FactoryGirl.create :organization, account: account
    membership   = FactoryGirl.create :membership, employee: employee, organization: organization
  }).to change(Account, :count).by(0)
end


Given /^mr burns, owner of the Springfield Nuclear Power Plant exists$/ do
  step %{a mr burns exists}
  step %{a user "mr burns" should exist}
  step %{a employee_owner "mr burns" should exist}
  step %{an account "springfield" should exist}
  step %{a organization "sector 7g" should exist}
  step %{a blog "sector 7g" should exist}
  if Capybara.current_session.driver.respond_to?(:rack_server)
    STDERR.puts "WARNING: can not set accept language header in javascript feature"
  else
    step %{I use a german browser}
  end
end
