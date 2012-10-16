# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

require 'factory_girl'
FactoryGirl.reload

if Rails.env.development?
  require 'database_cleaner'
  DatabaseCleaner.clean_with :truncation

  ActionMailer::Base.delivery_method = :test

  #########################
  # Organization Cileos  #
  ########################

  include FactoryGirl::Syntax::Default

  # Seeds currently contain only one account. Let's try to model Cileos as accurate as we can.

  cileos      = create :account, name: 'Cileos'

  clockwork = create :organization, name: 'Clockwork', account: cileos
  software = clockwork.plans.create! name: "Softwareentwicklung"
  clockwork.blogs.create! title: "Cileos Blog"

  owner = create :confirmed_user, email: 'owner@dev.shiftplan.de'
  create :employee_owner, account: cileos, user: owner, first_name: 'Fritz', last_name: 'Thielemann'

  # cileos has no real planning, it is done by destiny
  planner = create :confirmed_user, email: 'planner@dev.shiftplan.de'
  shakira = create :employee_planner, account: cileos, user: planner, first_name: 'Shakira', last_name: 'Schicksal'

  user_with_multiple_employees = create :confirmed_user, email: 'poweruser@dev.shiftplan.de'
  niklas = create :employee, account: cileos, user: user_with_multiple_employees, first_name: 'Niklas', last_name: 'Hofer', weekly_working_time: 40
  raphaela = create :employee, account: cileos, first_name: 'Raphaela', last_name: 'Wrede', weekly_working_time: 38

  [niklas, raphaela].each do |empl|
    create :membership, employee: empl, organization: clockwork
  end

  ##########################
  # Organization Wurstbrot #
  ##########################
  # a special organization niklas works totally alone

  wurstbrot = create :organization, name: 'Wurstbrot', account: cileos
  [niklas].each do |empl|
    create :membership, employee: empl, organization: wurstbrot
  end

  # mom will never be invited
  mom = create :employee, account: cileos, first_name: 'Mama', last_name: 'X.', weekly_working_time: 80

  released = software.milestones.create! name: 'Released', due_at: 1.month.from_now
  released.tasks.create! name: 'Plans', due_at: 1.week.from_now
  released.tasks.create! name: 'Employees', due_at: 2.weeks.from_now
  released.tasks.create! name: 'Meilensteine', due_at: 4.weeks.from_now
end # only in development environment

