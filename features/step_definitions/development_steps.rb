When /^I pause|try pry|I pry|I debug$/ do
  STDERR.puts "Pausing..."
  if system(%Q~which zenity~)
    if system(%Q~zenity --question --text="Paused. Want to pry?"~)
      binding.pry
    end
  else
    # no zenity installed, pry without asking
    binding.pry
  end
end

When /^nothing$/ do
  # for scenario outlines
end
