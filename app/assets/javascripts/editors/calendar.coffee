class CalendarEditor extends View
  @content: ->
    @div class: 'wrapperagainsfind', =>
      @div class: 'schedulings', outlet: 'list'

  initialize: (params) ->
    @element = params.element
    if @element.is('.scheduling') # single scheduling given => edit it
      $.ajax
        url: @edit_url()
        complete: @setupInputs
    else # cell given, assuming it is empty, => create new
      $.ajax
        url: @new_url()
        data: @params_for_new()
        complete: @setupInputs

  params_for_new: ->
    table = @element.closest('table')
    if table.is('.schedulings')
      @params_for_new_scheduling()
    else if table.is('.shifts')
      @params_for_new_shift()

  # we do not generate URIs on the Rails side as the Router is slow on many records
  # and we assume the URIs for schedulings are nested under the calendar
  # new_url from table: /accounts/1/organizations/1/plans/1/schedulings/new
  # resulting edit_url: /accounts/1/organizations/1/plans/1/schedulings/5/edit
  edit_url: ->
    @new_url().replace(/new$/, "#{@element.data('cid')}/edit")

  new_url: ->
    @element.closest('table').data('new_url')


  params_for_new_scheduling: ->
    scheduling:
      employee_id: @element.data('employee-id')
      date:        @element.data('date')
      team_id:     @element.data('team-id')

  params_for_new_shift: ->
    shift:
      day:     @element.data('day')
      team_id: @element.data('team-id')

  modal: ->
    $('#modalbox')

  setupInputs: =>
    @setupForm()
    @addTabIndices()

  setupForm: ->
    Clockwork.SchedulingEditor.create element: @modal().find('form:first')

  addTabIndices: ->
    tabIndex = 1
    for input in @modal().find('input,select,button')
      $(input).attr('autofocus', 'true') if tabIndex == 1
      $(input).attr('tabIndex', tabIndex)
      tabIndex++

window.CalendarEditor = CalendarEditor

