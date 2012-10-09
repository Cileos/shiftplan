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
  index = 0
  last = nil
  sentences = File.read(path).lines.map do |line|
    index += 1
    line.chomp!
    next if line.blank?
    if line.lstrip.starts_with?('|') # a table
      last << line
      nil
    else
      last = [index, line]
    end
  end.compact

  sentences.each do |lines|
    index = lines.shift
    process_situation_steps lines, file, index
  end
end

def process_situation_steps(s, file, index)
  if s.size > 1
    steps(out = s.join("\n"))
  else
    step(out = s.first.lstrip.sub(/^\w+\s+/,''))
  end
rescue Exception => e
  raise "#{e}\n#{file}:#{index}\n #{out}"
end
