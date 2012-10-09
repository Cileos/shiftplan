# If this file becomes to big, please consider tidying it up by splitting into
# other steps files

Given /^today is ([^,]+)$/ do |timey|
  Timecop.travel Time.zone.parse(timey)
end

Given /^today is (\w+day), the (.+)$/i do |day, timey|
  time = Time.zone.parse(timey)
  time.strftime('%A').downcase.should == day.downcase
  Timecop.travel time
end

After do
  Timecop.return
end

# experiment: shared backgrounds. Put loose steps into
# features/situations/a_perfect_world.steps, so you can say
#   Given the situation of a perfect world
Given /^the situation of ([\w ]+)$/ do |situation|
  file = situation.downcase.gsub(/\s+/,'_')
  path = Rails.root/"features"/"situations"/"#{file}.steps"
  last = nil
  File.read(path).lines.each_with_index do |line, index|
    unless last.blank?
      if line.lstrip.starts_with?('|') # a table
        last << line
        next
      else
        process_situation_steps last, file, index
      end
    end
    last = nil
    last = line unless line.blank?
  end
  process_situation_steps last, file, 'last'
end

def process_situation_steps(s, file, index)
  if s.lines.count > 1
    steps s
  else
    Rails.logger.debug "step: #{s}"
    step s.lstrip.sub(/^\w+\s+/,'').chomp
  end
rescue Exception => e
  raise "#{e}\n#{file}:#{index}\n #{last}"
end
