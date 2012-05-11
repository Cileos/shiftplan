# Two arguments for new:
#   $calendar: a jquery object pointing to the calendar table
#   tds:       which tds do we want to navigate
class CalendarCursor
  constructor: (@$calendar, @tds = 'td:not(.wwt_diff)') ->

    @$body     = @$calendar.find('tbody:first')

    # TODO better trigger the event on the cell and let it bubble up?
    @$calendar.bind 'calendar.cell_focus', (event, cell) =>
      $cell = $(cell)
      @focussed_cell().removeClass('focus')
      $cell.addClass('focus')

    $calendar = @$calendar
    @$calendar.on 'click', @tds, ->
      $calendar.trigger 'calendar.cell_focus', this
      $calendar.trigger 'calendar.cell_activate', this

    # focus first calendar data cell
    @$calendar.trigger 'calendar.cell_focus', @$body.find('tr:nth-child(1) td:nth-child(2)')

    @enable()

    # Disable keydown event handler as we want to press enter in the opening modal window to submit the form.
    $('body').on 'show', @disable

    # The keydown event handler 'CalendarCursor#keydown' gets disabled when the modal window for creating
    # schedulings opens so that the user should can press the "return" key to submit the form.
    # Therefore we must reenable the keydown event handler when the modal window was hidden:
    $('body').on 'hidden', @enable


  focussed_cell: ->
    @$body.find('td.focus')

  focus: ($target) ->
    @$calendar.trigger 'calendar.cell_focus', $target

  keydown: (event) =>
    switch event.keyCode
      when 13, 65, 78 # Enter, _a_dd, _n_ew
        # Trigger 'calendar.cell_activate' event. The handler will open the modal window for creating a new scheduling.
        @$calendar.trigger 'calendar.cell_activate', @focussed_cell()
        return
      when 37 # arrow left
        @left()
      when 39 # arrow right
        @right()
      when 38 # arrow up
        @up()
      when 40 # arrow down
        @down()

  # sets all the instance vars needed for navigation
  orientate: ->
    @$focussed_cell  = @focussed_cell()
    @current_column  = @$focussed_cell.closest('tr').children(@tds).index(@$focussed_cell)
    @current_row     = @$focussed_cell.closest('tbody').children('tr').index(@$focussed_cell.closest('tr'))
    @rows_count      = @$focussed_cell.closest('tbody').children('tr').size()
    @columns_count   = @$focussed_cell.closest('tr').children(@tds).size()


  left: ->
    @orientate()
    @focus @$focussed_cell.closest('tr').children(@tds).eq(@current_column-1)

  right: ->
    @orientate()
    @focus @$focussed_cell.closest('tr').children(@tds).eq( (@current_column+1) % @columns_count )

  up: ->
    @orientate()
    @focus @$focussed_cell.closest('tbody').children('tr').eq( (@current_row-1) % @rows_count ).children(@tds).eq(@current_column)

  down: ->
    @orientate()
    @focus @$focussed_cell.closest('tbody').children('tr').eq( (@current_row+1) % @rows_count ).children(@tds).eq(@current_column)

  enable: =>
    @disable()
    $('body').bind 'keydown', @keydown

  disable: =>
    $('body').unbind 'keydown', @keydown


window.CalendarCursor = CalendarCursor
