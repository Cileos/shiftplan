class CalendarEditor extends View
  @content: ->
    @div class: 'wrapperagainsfind', =>
      @div class: 'schedulings', outlet: 'list'

  initialize: (params) ->
    @element = params.element
    if @element.is('.scheduling') # single scheduling given => edit it
      $.ajax
        url: @element.data('edit_url')
        complete: @setupInputs
    else # cell given, assuming it is empty, => create new
      $.ajax
        url: @element.closest('table').data('new_url')
        data:
          scheduling:
            employee_id: @element.data('employee_id')
            date:        @element.data('date')
            team_id:     @element.data('team_id')
        complete: @setupInputs

  modal: ->
    $('#modalbox')

  setupInputs: =>
    @setupForm()
    @addTabIndices()

  setupForm: ->
    @modal().find('input[name="scheduling[quickie]"]').edit_quickie()

  addTabIndices: ->
    tabIndex = 1
    for input in @modal().find('input[type=text],select,button')
      $(input).attr('autofocus', 'true') if tabIndex == 1
      $(input).attr('tabIndex', tabIndex)
      tabIndex++

window.CalendarEditor = CalendarEditor

