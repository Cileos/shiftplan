# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'factory_girl'
FactoryGirl.reload

Shiftplan::Application.config.action_mailer.delivery_method = :test

unless planner = User.find_by_email('planner@dev.shiftplan.de')
  planner = Factory :planner, :email => 'planner@dev.shiftplan.de'
end
