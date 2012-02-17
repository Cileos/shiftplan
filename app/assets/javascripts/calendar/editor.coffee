# TODO I18n
class SchedulingEditor extends View
  @content: ($scheduling) ->
    id = $scheduling.data('id') || 'new'
    name = "scheduling_#{id}"
    @form class: 'form-inline well', 'data-remote': true, id: "edit_#{name}", =>
      @label "Quickie", for: "#{name}_quickie"
      @input type: 'text', value: $scheduling.text(), id: "#{name}_quickie"
      @button 'Speichern', type: 'submit', class: 'btn btn-mini btn-info'


class CalendarEditor extends View
  @content: ->
    @div class: 'wrapperagainsfind', =>
      @div class: 'schedulings', outlet: 'list'

  initialize: (params) ->
    for scheduling in params.cell.find('li')
      @addScheduling($(scheduling))
    @list.append params.form

  addScheduling: ($scheduling) ->
    @list.append new SchedulingEditor($scheduling)


window.CalendarEditor = CalendarEditor
