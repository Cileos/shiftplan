# TODO test _calendar.html

class CalendarEditor extends View
  @content: ->
    @div class: 'wrapperagainsfind', =>
      @div class: 'schedulings', outlet: 'list'

  initialize: (params) ->
    for scheduling in params.cell.find('li')
      @addScheduling($(scheduling))
    @addNewForm params.form, params.cell
    @addTabIndices()

  setupAutocomplete: ->

  addTabIndices: ->
    tabIndex = 1
    for input in @list.find('input[type=text],select,button')
      $(input).attr('tabIndex', tabIndex)
      tabIndex++

  addScheduling: ($scheduling) ->
    @list.append new SchedulingEditor scheduling: $scheduling, quickies: gon.quickie_completions

  addNewForm: ($form, $cell) ->
    $form.find(':input#scheduling_employee_id').val($cell.data('employee_id')).change()
    $form.find(':input#scheduling_date').val($cell.data('date')).change()
    @list.append $form


window.CalendarEditor = CalendarEditor

