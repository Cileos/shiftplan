require 'zeus/rails'

class CustomPlan < Zeus::Rails

  # def my_custom_command
  #  # see https://github.com/burke/zeus/blob/master/docs/ruby/modifying.md
  # end

  def cucumber_environment
    require 'cucumber/rspec/disable_option_parser'
    require 'cucumber/cli/main'
    @cucumber_runtime = Cucumber::Runtime.new
  end

  def cucumber(argv=ARGV)
    cucumber_main = Cucumber::Cli::Main.new(argv.dup)
    had_failures = cucumber_main.execute!(@cucumber_runtime)
    exit_code = had_failures ? 1 : 0
    exit exit_code
  end
end

Zeus.plan = CustomPlan.new
