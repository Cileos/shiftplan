module HtmlSelectorsHelpers
  Numerals = {
    'first'  => ':first',
    'second' => ':nth-of-type(2)',
    'third'  => ':nth-of-type(3)',
    'forth'  => ':nth-of-type(4)'
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
      'nav[role=navigation]'

    when 'the user navigation'
      '.user-navigation'

    when 'the content'
      'section[role=content]'

    when "the calendar"
      'table#calendar'

    when "the calendar caption"
      'header.calendar-caption h3'

    when "the legend"
      '#legend'

    when 'the toolbar'
      'nav[role=toolbar]'

    when 'the modal box'
      'div#modalbox'

    when 'the completion list'
      'ul.ui-autocomplete'

    when 'errors'
      '.errors.alert.alert-error'

    when 'the spinner'
      '#spinner'

    when /^the #{capture_nth} active tab$/
      ".tabbable#{Numerals[$1]} .tab-pane.active"

    when /^the comment link$/
      'a.comments'

    when /^the #{capture_nth} form$/
      "form#{Numerals[$1]}"

    when %r~^(?:the )?cell "([^"]+)"/"([^"]+)"$~
      column = column_index_for($1)
      row    = row_index_for($2)
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

  # 0-based index of column headed by given label
  def column_index_for(column_label)
    columns = page.all('thead tr th').map { |c| extract_text_from_cell c }
    columns.should include(column_label)
    columns.index(column_label)
  end

  # 0-based index of row (in tbody) headed by given label
  def row_index_for(row_label)
    rows = page.all("tbody th").map { |c| extract_text_from_cell c }
    rows.should include(row_label)
    rows.index(row_label)
  end

  SelectorsForTextExtraction = ['.day_name', '.employee_name', '.work_time', '.team_name', 'a.button.active', 'li.dropdown a.button']
  def extract_text_from_cell(cell)
    tried = 0
    found = SelectorsForTextExtraction.select { |s| cell.all(s).count > 0 }
    if found.present?
      found.map { |f| cell.all(f).map(&:text).map(&:strip) }.flatten.join(' ')
    else
      cell.text.strip
    end
  rescue Timeout::Error => e
    # sometimes the finding takes too long and travis times out.
    if tried < 1
      tried += 1
      retry
    else
      raise e
    end
  end

end

World(HtmlSelectorsHelpers)
