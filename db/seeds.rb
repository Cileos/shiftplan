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

organization = Organization.find_or_create_by_name 'Cileos'

unless planner = User.find_by_email('planner@dev.shiftplan.de')
  planner = Factory :confirmed_user, email: 'planner@dev.shiftplan.de'
  Factory :employee, organization: organization, user: planner, role: 'planner'
end

unless owner = User.find_by_email('owner@dev.shiftplan.de')
  owner = Factory :confirmed_user, email: 'owner@dev.shiftplan.de'
  Factory :employee, organization: organization, user: owner, role: 'owner'
end

if organization.plans.empty?
  organization.plans.create! name: "Coden"
end
