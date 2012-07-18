## Possible Keys
# :null, :cancel, :help, :backspace, :tab, :clear, :return, :enter, :shift, :left_shift, :control, :left_control :alt, :left_alt, :pause,
# :escape, :space:page_up, :page_down, :end, :home, :left, :arrow_left, :up:arrow_up, :right, :arrow_right:down, :arrow_down, :insert,
# :delete, :semicolon, :equals, :numpad0, :numpad1, :numpad2, :numpad3, :numpad4, :numpad5, :numpad6, :numpad7, :numpad8, :numpad9,
# :multiply, :add, :separator, :subtract, :decimal, :divide
#

# And I send "hello" to "#element"
# And /^I send (#{allowed_keys.join('|')}) to "([^\"]*)"$/ do |key, element|
And /^I send (.*) to "(.*)"$/ do |key, element|
  find(element).send_string_of_keys(key)
end

def directions
  ['arrow up','arrow down','arrow right','arrow left','return','escape', 'tab', 'enter'].join('|')
end

When /^I press (#{directions})$/ do |direction|
  direction.gsub!(' ', '_')
  step %{I send #{direction} to "body"}
end

When /^I press (#{directions}) in the #{capture_quoted} field$/ do |key, field|
  key.gsub!(' ', '_')
  find_field(field).send_string_of_keys(key)
end

When /^I press key #{capture_quoted}$/ do |key|
  find('body').send_string_of_keys(key)
end

When /^I press (#{directions}) (\d{1,2}) times$/ do |direction, times|
  times.to_i.times do
    step %{I press #{direction}}
  end
end

