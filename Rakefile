#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

if ENV['CI'].to_s == 'true'
  require 'ci/reporter/rake/rspec'     # use this if you're using RSpec
  require 'ci/reporter/rake/cucumber'  # use this if you're using Cucumber
  require 'ci/reporter/rake/minitest'  # use this if you're using Ruby 1.9 or minitest
end

Shiftplan::Application.load_tasks
