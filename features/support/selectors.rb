module HtmlSelectorsHelpers
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

    when /^the ([a-zA-Z ]+) table$/
      "table##{$1.gsub(' ', '-')}"

    when 'the navigation'
      'nav[role=navigation]'

    when /^the (\w+) module$/
      ".dashboard .module.#{$1}"

    when /the (account|organization) dropdown list/
      selector_for('the navigation') + " ul.#{$1}-dropdown"

    when 'the user navigation'
      '.user-navigation'

    when 'the content'
      'section[role=content]'

    when "the calendar"
      'table#calendar'

    when "the calendar caption"
      'header h2.calendar-caption'

    when "the legend"
      '#legend'

    when 'the toolbar'
      'nav[role=toolbar]'

    when 'the modal box'
      'div#modalbox'

    when /^the modal box (?:header|title)$/
      '.ui-dialog .ui-dialog-title'

   # the "done" milestone checkbox
   when /^#{capture_quoted} (\w+) checkbox$/
     %Q~input.#{$2}[name="#{$1}"]~

    when 'the completion list'
      'ul.ui-autocomplete'

    when 'errors'
      '.errors.alert.flash'

    when 'the spinner'
      '#spinner'

    when /^the #{capture_nth} active tab$/
      ".tabbable#{Numerals[$1]} .tab-pane.active"

    when /^the #{capture_nth} table row$/
      "table tbody tr#{Numerals[$1]}"

    # The following links are decorated with tipsy, which uses the @title attribute and moves it to @original-title
    when /^the comments? link$/
      %Q~a.comments[original-title]~ # check only for presence of o-t; it is pluralized, depending on number of comments

    when /^the delete link$/
      %Q~a[data-method="delete"][original-title="#{I18n.translate('helpers.actions.destroy')}"]~

    when /^the #{capture_nth} form$/
      "form#{Numerals[$1]}"

    when /^the #{capture_nth} item/
      "li#{Numerals[$1]}"

    when /^a cell outside the plan period$/
      'td.outside_plan_period'

    when /^a cell inside the plan period$/
      'td:not(.outside_plan_period)'

    when %r~^(?:the )?cell "([^"]+)"/"([^"]+)"$~
      column = the_calendar.column_index_for($1)
      row    = the_calendar.row_index_for($2)
      "tbody tr:nth-child(#{row+1}) td:nth-child(#{column+1})"

    when 'a hint'
      '.hint'

    when 'the pagination'
      '.pagination'

    when 'the comments'
      'ul#comments'

    when 'comments'
      "ul.comments"
    when 'replies'
      '.replies'

    when 'the cursor'
      '.with_cursor .focus'

    when /^(?: a |the )?(\w+) list$/
      "ul.#{$1}"

    when /^the #{capture_nth} (post)/
      ".#{$2}#{Numerals[$1]}"

    when 'active week'
      '.calendar-active-week'

    when 'weeks first date'
      '#calendar thead th:nth-child(2) .date-without-year'

    when 'merge button'
      'button#merge-button'

    when 'adopt employee button'
      'form#add-members button'

    when 'the add members form'
      'form#add-members'

    when 'the search form'
      'form#search'

    when 'the duplication warning'
      'div#duplication-warning'

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

  private


  # will be cleared after each Scenario
  def the_calendar
    @the_calendar ||= CalendarHelpers::Calendar.new(self)
  end

end

World(HtmlSelectorsHelpers)
After do
  @the_calendar = nil
end
