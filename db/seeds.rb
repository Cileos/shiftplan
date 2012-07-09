# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'factory_girl'
FactoryGirl.createGirl.reload

require 'database_cleaner'
DatabaseCleaner.clean_with :truncation

ActionMailer::Base.delivery_method = :test

#########################
# Organization Cileos  #
########################

organization = FactoryGirl.create :organization, name: 'Cileos'
organization.plans.create! name: "Softwareentwicklung"
organization.blogs.create! title: "Cileos Blog"

owner = FactoryGirl.create :confirmed_user, email: 'owner@dev.shiftplan.de'
FactoryGirl.create :employee, organization: organization, user: owner, role: 'owner', first_name: 'Fritz', last_name: 'Thielemann'

planner = FactoryGirl.create :confirmed_user, email: 'planner@dev.shiftplan.de'
FactoryGirl.create :employee, organization: organization, user: planner, role: 'planner', first_name: 'Carl', last_name: 'Carlson'

user_with_multiple_employees = FactoryGirl.create :confirmed_user, email: 'poweruser@dev.shiftplan.de'
FactoryGirl.create :employee, organization: organization, user: user_with_multiple_employees, first_name: 'Niklas', last_name: 'Hofer', weekly_working_time: 40

FactoryGirl.create :employee, organization: organization, first_name: 'Raphaela', last_name: 'Wrede', weekly_working_time: 38


########################
# Organization Apple  #
#######################

apple = FactoryGirl.create :organization, name: 'Apple'
apple.plans.create! name: "Produktdesign"
apple.blogs.create! title: "Apple Blog"

owner_apple = FactoryGirl.create :confirmed_user, email: 'owner@dev.apple.de'
FactoryGirl.create :employee, organization: apple, user: owner_apple, role: 'owner', first_name: 'Steve', last_name: 'Jobs'

planner_apple = FactoryGirl.create :confirmed_user, email: 'planner@dev.apple.de'
FactoryGirl.create :employee, organization: apple, user: planner_apple, role: 'planner', first_name: 'Anton', last_name: 'Cook'

FactoryGirl.create :employee, organization: apple, user: user_with_multiple_employees, first_name: 'N.', last_name: 'Hofer', weekly_working_time: 42

FactoryGirl.create :employee, organization: apple, first_name: 'Rolf', last_name: 'Eden', weekly_working_time: 40
