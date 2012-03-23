class CalendarEditor extends View
  @content: ->
    @div class: 'wrapperagainsfind', =>
      @div class: 'schedulings', outlet: 'list'

  initialize: (params) ->
    if params.cell.find('li').length > 0
      $.ajax
        url: params.cell.closest('table').data('edit_url')
        data:
          ids: ($(sch).data('id') for sch in params.cell.find('li'))
        complete: =>
          @addTabIndices()
    else
      $.ajax
        url: params.cell.closest('table').data('new_url')
        data:
          scheduling:
            employee_id: params.cell.data('employee_id')
            date:        params.cell.data('date')
        complete: =>
          @addTabIndices()

  modal: ->
    $('#scheduling_modal')

  # TODO make QuickieEditor less intrusive
  setupFormsInModal: ->
    for quickie in @modal().find('input[name="scheduling[quickie]"]')
      $(quickie).closest('.control-group').replaceWith new QuickieEditor

  addTabIndices: ->
    tabIndex = 1
    for input in @modal().find('input[type=text],select,button')
      $(input).attr('tabIndex', tabIndex)
      tabIndex++

window.CalendarEditor = CalendarEditor

