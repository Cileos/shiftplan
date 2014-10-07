# A sample Guardfile
# More info at https://github.com/guard/guard#readme

group :test, :halt_on_fail => true do

  guard 'rspec',
    cmd: "zeus rspec --color --format nested --tag ~benchmark",
    run_all: {
      cli: "--color --tag ~benchmark"
    },
    failed_mode: :focus,
    all_on_start: false,
    all_after_pass: false do

    # Rails example
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^app/((?:models|helpers|widgets|decorators|inputs|services)/.+)\.rb$})         { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^app/mailers/(.+)\.rb$})                     { |m| "spec/mailers/#{m[1]}_spec.rb" }
    watch(%r{^lib/(.+)\.treetop$})                      { |m| "spec/lib/#{m[1]}_parser_spec.rb" }
    watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
    # we (will) use cucumber extensivly
    # watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
    #watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
    #watch('spec/spec_helper.rb')                        { "spec" }
    watch('config/routes.rb')                           { "spec/routing" }
    # watch('app/models/ability.rb')                      { "spec/abilities" }
    # Capybara request specs
    watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/requests/#{m[1]}_spec.rb" }

    watch(%r{^spec/support/shared/conflict_finder.rb$}) { ['spec/services/conflict_finder_spec.rb', 'spec/services/user_conflict_finder_spec.rb'] }
  end

  guard 'jasmine', :all_on_start => false do
    watch(%r{app/assets/javascripts/(.+)\.(js\.coffee|js|coffee)$}) { |m| "spec/javascripts/#{m[1]}_spec.#{m[2]}" }
    watch(%r{spec/javascripts/(.+)_spec\.(js\.coffee|js|coffee)$})  { |m| puts m.inspect; "spec/javascripts/#{m[1]}_spec.#{m[2]}" }
    watch(%r{spec/javascripts/spec\.(js\.coffee|js|coffee)$})       { "spec/javascripts" }
  end if ENV['JASMINE']

  ENV['CUCUMBER_FORMAT'] = 'fuubar'
  ENV['CAPYBARA_CHROME'] = 'yes'
  guard 'cucumber',
    :cli => "--no-source --no-profile --strict --format pretty --format rerun --out rerun.txt --tags ~@wip",
    command_prefix: 'zeus',
    bundler: false,
    :keep_failed => false,
    :run_all => { :cli => "--format fuubar --tags ~@wip" },
    :all_on_start => false,
    :all_after_pass => false do
    watch(%r{^features/.+\.feature$})
    watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0]  }
    #watch('app/decorators/scheduling_filter_decorator.rb') { 'features/plan/*.feature' }

    callback(:run_all_end) do
      # update todo file
      system 'script/todo'
    end
  end

end

guard 'bundler' do
  watch('Gemfile')
end
