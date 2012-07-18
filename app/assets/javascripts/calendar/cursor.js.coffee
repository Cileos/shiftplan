# Two arguments for new:
#   $calendar: a jquery object pointing to the calendar table
#   tds:       which tds do we want to navigate
#   items:     items within the tds
class CalendarCursor
  constructor: (@$calendar, @tds = 'td:not(.wwt_diff)', @items = '.scheduling') ->

    @$body     = @$calendar.find('tbody:first')

    $calendar = @$calendar
    @$calendar.on 'click', @tds, (event) =>
      $target = $(event.target)
      return true if $target.is('a,i') # keep rails' remote links working
      @focus $target.closest(@tds)
      @activate()
      false

    @$calendar.on 'click', "#{@tds} #{@items}", (event) =>
      $target = $(event.target)
      return true if $target.is('a,i') # keep rails' remote links working
      @focus $target.closest(@items), null
      @activate()
      false

    @$calendar.on 'update', => @refocus()

    # focus first calendar data cell
    @focus @$body.find('tr:nth-child(1) td:nth-child(2)')

    @enable()

    # Disable keydown event handler as we want to press enter in the opening modal window to submit the form.
    $('body').on 'dialogopen', @disable

    # The keydown event handler 'CalendarCursor#keydown' gets disabled when the modal window for creating
    # schedulings opens so that the user should can press the "return" key to submit the form.
    # Therefore we must reenable the keydown event handler when the modal window was hidden:
    $('body').on 'dialogclose', @enable


  focussed_cell: ->
    @$body.find('td.focus')

  focus: ($target, item_select) ->
    if item_select? and $target.has(@items).length > 0
      $target = $target.find(@items)[item_select]()
    @$calendar.find('.focus').removeClass('focus')
    $target.closest('td').addClass('focus') unless $target.is('td')
    $target.addClass('focus')
    scroll_to($target)


  refocus: ->
    if @$focussed_item? and @$focussed_item.length > 0
      @focus @$calendar.find('tbody').children('tr').eq(@current_row).children(@tds).eq(@current_column).find(@items).eq(@current_item_index)
    else
      @focus @$calendar.find('tbody').children('tr').eq(@current_row).children(@tds).eq(@current_column), 'first'


  keydown: (event) =>
    captured = true
    switch event.keyCode
      when 65, 78 # _a_dd, _n_ew
        @orientate()
        @create()
      when 13, 69 # Enter, _e_dit
        @activate()
      when 67 # _c_omments
        @orientate()
        @$focussed_item.find('a.comments').trigger('click.rails')
      when 37, 72 # arrow left
        @left()
      when 39, 76 # arrow right
        @right()
      when 38, 75 # arrow up
        @up()
      when 40, 74 # arrow down
        @down()
      else
        captured = false
    if captured
      event.stopPropagation()
      event.preventDefault()
      false
    else
      true

  scroll_to = (elem)->
    h = $(window).height() / 3
    $('html, body').animate({
        scrollTop: elem.offset().top - h
    },200)

  # sets all the instance vars needed for navigation
  orientate: ->
    @$focussed_cell  = @focussed_cell()
    @current_column  = @$focussed_cell.closest('tr').children(@tds).index(@$focussed_cell)
    @current_row     = @$focussed_cell.closest('tbody').children('tr').index(@$focussed_cell.closest('tr'))
    @rows_count      = @$focussed_cell.closest('tbody').children('tr').size()
    @columns_count   = @$focussed_cell.closest('tr').children(@tds).size()
    @$items          = @$focussed_cell.find(@items)
    if @$items.length > 0
      @$focussed_item = @$items.filter('.focus')
      @current_item_index = @$items.index(@$focussed_item)
    else
      @$focussed_item = $()
      @current_item_index = null

  activate: ->
    @orientate()
    if @$focussed_item.length > 0
      @edit()
    else
      @create()

  edit: ->
    new CalendarEditor element: @$focussed_item

  create: ->
    new CalendarEditor element: @$focussed_cell

  left: ->
    @orientate()
    @focus @$focussed_cell.closest('tr').children(@tds).eq(@current_column-1), 'first'

  right: ->
    @orientate()
    @focus @$focussed_cell.closest('tr').children(@tds).eq( (@current_column+1) % @columns_count ), 'first'

  up: ->
    @orientate()
    if @$items.length > 1 # there are items to navigate
      if @$focussed_item.length > 0 # some item focussed
        if @current_item_index == 0 # at the top
          @row_up()
        else
          @focus @$items.eq( @current_item_index - 1)
      else # none focussed yet
        @focus @$items.last()
    else
      @row_up()

  row_up: ->
    @focus @$focussed_cell.closest('tbody').children('tr').eq( (@current_row-1) % @rows_count ).children(@tds).eq(@current_column), 'last'

  down: ->
    @orientate()
    if @$items.length > 1 # there are items to navigate
      if @$focussed_item.length > 0 # some item focussed
        if @current_item_index >= @$items.length-1 # at the end
          @row_down()
        else
          @focus @$items.eq( @current_item_index + 1)
      else # none focussed yet
        @focus @$items.first()
    else
      @row_down()

  row_down: ->
    @focus @$focussed_cell.closest('tbody').children('tr').eq( (@current_row+1) % @rows_count ).children(@tds).eq(@current_column), 'first'

  enable: =>
    @disable()
    $('body').bind 'keydown', @keydown

  disable: =>
    $('body').unbind 'keydown', @keydown


window.CalendarCursor = CalendarCursor
