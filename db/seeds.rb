# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'factory_girl'
FactoryGirl.reload

require 'database_cleaner'
DatabaseCleaner.clean_with :truncation

ActionMailer::Base.delivery_method = :test

#########################
# Organization Cileos  #
########################

organization = Factory :organization, name: 'Cileos'
organization.plans.create! name: "Softwareentwicklung"

owner = Factory :confirmed_user, email: 'owner@dev.shiftplan.de'
Factory :employee, organization: organization, user: owner, role: 'owner', first_name: 'Owner', last_name: 'Carlson'

planner = Factory :confirmed_user, email: 'planner@dev.shiftplan.de'
Factory :employee, organization: organization, user: planner, role: 'planner', first_name: 'Planner', last_name: 'Burns'

Factory :employee, organization: organization, first_name: 'Employee', last_name: 'Hofer', weekly_working_time: 40
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

Factory :employee, organization: apple, first_name: 'Employee', last_name: 'Meyer', weekly_working_time: 42

Factory :employee, organization: apple, first_name: 'Employee', last_name: 'Carlson', weekly_working_time: 40