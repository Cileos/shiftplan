# Two arguments for new:
#   $calendar: a jquery object pointing to the calendar table
#   tds:       which tds do we want to navigate
class CalendarCursor
  constructor: (@$calendar, @tds = 'td:not(.hours)') ->

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

    # TODO
    # Don't know why the following line
    #
    # $('#scheduling_modal').on 'hidden', @enable
    #
    # does not work. @enable gets called when modal closes, yet keydown events are not triggered.
    # Only difference: When @enable gets called, 'this' is the #scheduling dom element in the @enable function while
    # 'this' is the curser in the current implementation.
    $curser = this
    $('#scheduling_modal').on 'hidden', ->
      $curser.enable()


  focussed_cell: ->
    @$body.find('td.focus')

  columns_count: ->
    @focussed_cell().closest('tr').children(@tds).size()

  rows_count: ->
    @focussed_cell().closest('tbody').children('tr').size()

  keydown: (event) =>
    $focus  = @focussed_cell()
    if event.keyCode == 13 # enter
      # Trigger 'calendar.cell_activate' event. The handler will open the modal window for creating a new scheduling.
      @$calendar.trigger 'calendar.cell_activate', $focus
      return
    column  = $focus.closest('tr').children(@tds).index($focus)
    row     = $focus.closest('tbody').children('tr').index($focus.closest('tr'))
    $target = switch event.keyCode
      when 37 # arrow left
        $focus.closest('tr').children(@tds).eq(column-1)
      when 38 # arrow up
        if row - 1 < 0
          row = @rows_count() - 1
        else
          row = row - 1
        $focus.closest('tbody').children('tr').eq(row).children(@tds).eq(column)
      when 39 # arrow right
        $focus.closest('tr').children(@tds).eq( (column+1) % @columns_count() )
      when 40 # arrow down
        $focus.closest('tbody').children('tr').eq( (row+1) % @rows_count() ).children(@tds).eq(column)

    if $target
      @$calendar.trigger 'calendar.cell_focus', $target

  enable: ->
    $('body').bind 'keydown', @keydown

  disable: ->
    $('body').unbind 'keydown', @keydown


window.CalendarCursor = CalendarCursor
