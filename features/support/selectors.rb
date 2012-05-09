module HtmlSelectorsHelpers
  Numerals = {
    'first'  => ':first',
    'second' => ':nth-child(2)',
    'third'  => ':nth-child(3)',
    'forth'  => ':nth-child(4)'
  }

  def capture_nth
    /(#{Numerals.keys.join('|')})/
  end
  # Maps a name to a selector. Used primarily by the
  #
  #   When /^(.+) within (.+)$/ do |step, scope|
  #
  # step definitions in web_steps.rb
  #
  def selector_for(locator)
    case locator

    when "the page"
      "html > body"
    when "my list of recent achievements"
      "ul.achievements"

    when /^the new (.+) form$/
      "form#new_#{$1}"

    when /^(?:an|the) edit (.+) form$/
      "form.edit_#{$1}"

    when /^the row for employee "([^"]*)"$/
      employee = Employee.find_by_first_name_and_last_name($1.split[0], $1.split[1])
      "table#employees tr#employee_#{employee.id}"

    when /^the employees table$/
      "table#employees"

    when 'the navigation'
      '.navbar:first'

    when "the calendar"
      'table#calendar'

    when "the legend"
      '#legend'

    when "the calendar navigation"
      'div#calendar-navigation'

    when 'the modal box body'
      'div.modal div.modal-body'

    when 'the modal box'
      'div.modal'

    when 'errors'
      '.errors.alert.alert-error'

    when /^the #{capture_nth} active tab$/
      ".tabbable#{Numerals[$1]} .tab-pane.active"

    when /^the #{capture_nth} form$/
      "form#{Numerals[$1]}"

    when 'a hint'
      '.help-block'
    when 'the pagination'
      '.pagination'
    when 'the posts'
      'ul#posts'
    when 'the comments'
      'ul#comments'

    when 'comments'
      "ul.comments"
    when 'replies'
      '.replies'

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #  when /^the (notice|error|info) flash$/
    #    ".flash.#{$1}"

    # You can also return an array to use a different selector
    # type, like:
    #
    #  when /the header/
    #    [:xpath, "//header"]

    # This allows you to provide a quoted selector as the scope
    # for "within" steps as was previously the default for the
    # web steps:
    when /^"(.+)"$/
      $1

    when /^#{capture_model}$/
      model = model!($1)
      case model
      when Post
        "#post_#{model.id}"
      when Comment
        "#comment_#{model.id}"
      else
        raise ArgumentError, "cannot find selector for \"#{$1}\", please add it in #{__FILE__}:#{__LINE__}"
      end

    else
      raise "Can't find mapping from \"#{locator}\" to a selector.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(HtmlSelectorsHelpers)
