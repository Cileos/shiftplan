class CalendarEditor extends View
  @content: ->
    @div class: 'wrapperagainsfind', =>
      @div class: 'schedulings', outlet: 'list'

  initialize: (params) ->
    if params.cell.find('li').length > 0
      $.ajax
        url: params.cell.closest('table').data('edit_url')
        dataType: 'script'
        type: 'GET'
        data:
          ids: ($(sch).data('id') for sch in params.cell.find('li'))
        complete: =>
          @addTabIndices()

  addTabIndices: ->
    tabIndex = 1
    for input in @list.find('input[type=text],select,button')
      $(input).attr('tabIndex', tabIndex)
      tabIndex++

  addNewForm: (params) ->
    if params.form
      form = params.form.clone()
      form.find(':input#scheduling_employee_id').val(params.cell.data('employee_id')).change()
      form.find(':input#scheduling_date').val(params.cell.data('date')).change()
      form.find(':input#scheduling_quickie').closest('.control-group').replaceWith new QuickieEditor id: 'new', value: ''
      @list.append form


window.CalendarEditor = CalendarEditor

