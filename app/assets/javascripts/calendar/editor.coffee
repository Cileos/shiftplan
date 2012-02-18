# TODO test _calendar.html
class SchedulingEditor extends View
  @content: ($scheduling) ->
    id = $scheduling.data('id') || throw('scheduling without id given, needed to edit')
    name = "scheduling_#{id}"
    plan = $scheduling.closest('table').data('plan_id')
    # TODO routes for js
    @form class: 'form-horizontal well', 'data-remote': true, id: "edit_#{name}", method: "POST", action: "/plans/#{plan}/schedulings/#{id}", =>
      @input type: 'hidden', name: '_method', value: 'PUT'
      @div class: 'control-group quickie', =>
        @label "Quickie", for: "#{name}_quickie"
        @div class: 'controls', =>
          @input type: 'text', value: $scheduling.text(), id: "#{name}_quickie", name: 'scheduling[quickie]'
      # TODO I18n js
      @button 'Speichern', type: 'submit', class: 'btn btn-info'


class CalendarEditor extends View
  @content: ->
    @div class: 'wrapperagainsfind', =>
      @div class: 'schedulings', outlet: 'list'

  initialize: (params) ->
    for scheduling in params.cell.find('li')
      @addScheduling($(scheduling))
    @addNewForm params.form, params.cell

  addScheduling: ($scheduling) ->
    @list.append new SchedulingEditor($scheduling)

  addNewForm: ($form, $cell) ->
    $form.find(':input#scheduling_employee_id').val($cell.data('employee_id')).change()
    $form.find(':input#scheduling_date').val($cell.data('date')).change()
    @list.append $form


window.CalendarEditor = CalendarEditor
