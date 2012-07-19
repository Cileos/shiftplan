When /^I pause|try pry|I pry|I debug$/ do
  STDERR.puts "Pausing..."
  question = "Paused. Want to pry?"
  if system(%Q~which zenity~)
    if system(%Q~zenity --question --text="#{question}"~)
      binding.pry
    end
  elsif system(%Q~which osascript~)
    system(%Q~osascript -e 'tell app "System Events" to activate'~)
    if `osascript -e 'tell app "System Events" to display dialog "#{question}" buttons {"Yes", "No"}'`.chomp.include?('Yes')
      binding.pry
    end
  else
    # no zenity or osascript installed, pry without asking
    binding.pry
  end
end

When /^nothing$/ do
  # for scenario outlines
end
