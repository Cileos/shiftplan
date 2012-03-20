# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'factory_girl'
FactoryGirl.reload

ActionMailer::Base.delivery_method = :test

require 'database_cleaner'
DatabaseCleaner.clean_with :truncation


#########################
# Organization Cileos  #
########################

organization = Factory :organization, name: 'Cileos'
organization.plans.create! name: "Softwareentwicklung"

owner = Factory :confirmed_user, email: 'owner@dev.shiftplan.de'
Factory :employee, organization: organization, user: owner, role: 'owner', first_name: 'Owner', last_name: 'Carlson'

planner = Factory :confirmed_user, email: 'planner@dev.shiftplan.de'
Factory :employee, organization: organization, user: planner, role: 'planner', first_name: 'Planner', last_name: 'Burns'

employee_cileos = Factory :confirmed_user, email: 'employee@dev.shiftplan.de'
Factory :employee, organization: organization, user: employee_cileos, first_name: 'Employee', last_name: 'Hofer', weekly_working_time: 40
employee_cileos.invitation_accepted_at = Time.now
employee_cileos.save!

# employee_without_user(not yet invited)
Factory :employee, organization: organization, first_name: 'Employee', last_name: 'Wrede', weekly_working_time: 38


########################
# Organization Apple  #
#######################

apple = Factory :organization, name: 'Apple'
apple.plans.create! name: "Produktdesign"

owner_apple = Factory :confirmed_user, email: 'owner@dev.apple.de'
Factory :employee, organization: apple, user: owner_apple, role: 'owner', first_name: 'Owner', last_name: 'Jobs'

planner_apple = Factory :confirmed_user, email: 'planner@dev.apple.de'
Factory :employee, organization: apple, user: planner_apple, role: 'planner', first_name: 'Planner', last_name: 'Cook'

employee_apple = Factory :confirmed_user, email: 'employee@dev.apple.de'
Factory :employee, organization: apple, user: employee_apple, first_name: 'Employee', last_name: 'Meyer', weekly_working_time: 42
employee_apple.invitation_accepted_at = Time.now
employee_apple.save!

# employee_without_user(not yet invited)
Factory :employee, organization: apple, first_name: 'Employee', last_name: 'Carlson', weekly_working_time: 40

# The user 'employee_cileos' gets associated with another employee of org 'apple' and should see both orgs on the dashboard
Factory :employee, organization: apple, user: employee_cileos, first_name: 'Employee', last_name: 'Thielemann', weekly_working_time: 38