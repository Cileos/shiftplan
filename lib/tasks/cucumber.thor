class Cucumber < Thor

  # Usage examples for stepfinder thor task:
  #
  # $ bundle exec thor cucumber:find_step --search='the following'
  # Finds step definitions including the string 'the following'.
  #
  # $ bundle exec thor cucumber:find_step --search='the following' --refresh_steps
  # Fetches/refreshes stepsdefinition found in this app and in all other adva gems to be searched in.
  # All step definitions are written to a file 'features/support/stepdefs.txt'.
  # Then it finds step definitions including the string 'the following'.
  #
  # $ bundle exec thor cucumber:find_step --search='I should see the "Leckerhonig" page' --regex
  # Finds step definitions which match the string 'I should see the "Leckerhonig" page'.

  desc "find_step", "finds cucumber step definitions see README for usage instructions"

  class_option :search,        :required => true
  class_option :refresh_steps, :required => false
  class_option :regex,         :required => false

  def find_step
    search = options[:search]
    refresh_steps = options[:refresh_steps]
    regex = options[:regex]

    defs_file = 'features/support/stepdefs.txt'

    if !File.exists?(defs_file) or refresh_steps
      system "mkdir -p #{File.dirname(defs_file)}"
      system "cucumber --format usage features/stepfinder.feature > #{defs_file}"

      # Beautify generated step definition file by removing unneeded whitespace.
      text = File.read(defs_file) 
      text.gsub!(/\s*# features\//, ' # features/')
      File.open(defs_file, "w") { |file| file << text }
    end

    File.open(defs_file).each do |line|
      line = line.gsub(/\d+\.\d+/, '')
      next unless line =~ /#/
      step_def_regex_part = line.split('#')[0]
      if regex
        puts line if search =~ /#{step_def_regex_part.strip.gsub(/.*\/\^/,'').gsub(/\$\/.*/, '')}/
      else
        puts line if step_def_regex_part =~ /#{search}/
      end
    end
  end
end
