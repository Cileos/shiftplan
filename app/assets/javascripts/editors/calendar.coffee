# TODO test _calendar.html

class CalendarEditor extends View
  @content: ->
    @div class: 'wrapperagainsfind', =>
      @div class: 'schedulings', outlet: 'list'

  initialize: (params) ->
    for scheduling in params.cell.find('li')
      @addScheduling($(scheduling))
    @addNewForm params
    @addTabIndices()

  addTabIndices: ->
    tabIndex = 1
    for input in @list.find('input[type=text],select,button')
      $(input).attr('tabIndex', tabIndex)
      tabIndex++

  addScheduling: ($scheduling) ->
    @list.append new SchedulingEditor scheduling: $scheduling, quickies: gon.quickie_completions

  addNewForm: (params) ->
    params.form.find(':input#scheduling_employee_id').val(params.cell.data('employee_id')).change()
    params.form.find(':input#scheduling_date').val(params.cell.data('date')).change()
    params.form.find(':input#scheduling_quickie').closest('.control-group').replaceWith new QuickieEditor id: 'new', value: ''
    @list.append params.form


window.CalendarEditor = CalendarEditor

