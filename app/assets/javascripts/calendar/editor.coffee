# TODO test _calendar.html
class SchedulingEditor extends View
  @content: ($scheduling) ->
    id = $scheduling.data('id') || throw('scheduling without id given, needed to edit')
    name = "scheduling_#{id}"
    plan = $scheduling.closest('table').data('plan_id')
    url  = "/plans/#{plan}/schedulings/#{id}"
    # TODO routes for js
    @form class: 'form-horizontal well edit_scheduling', 'data-remote': true, id: "edit_#{name}", method: "POST", action: url, =>
      @input type: 'hidden', name: '_method', value: 'PUT'
      @a outlet: 'delete_button', class: 'btn btn-danger delete', href: url, 'data-remote': true, 'data-method': 'DELETE', =>
        @i class: 'icon-trash icon-white'
        # TODO I18n js
        @text ' Löschen'
      @div class: 'control-group quickie', =>
        @label "Quickie", for: "#{name}_quickie"
        @div class: 'controls', =>
          @input type: 'text', value: $scheduling.data('quickie'), id: "#{name}_quickie", name: 'scheduling[quickie]'
      @button type: 'submit', class: 'btn btn-info', =>
        @i class: 'icon-ok-circle icon-white'
        # TODO I18n js
        @text ' Speichern'

class CalendarEditor extends View
  @content: ->
    @div class: 'wrapperagainsfind', =>
      @div class: 'schedulings', outlet: 'list'

  initialize: (params) ->
    @setupAutocomplete()
    for scheduling in params.cell.find('li')
      @addScheduling($(scheduling))
    @addNewForm params.form, params.cell
    @addTabIndices()

  setupAutocomplete: ->
    # All quickie fields will be autocompleted, keybindings removed on modal box close
    @on 'attach', ->
      $(@).find(":input[name='scheduling[quickie]']:not(.typeahead)")
        .addClass('typeahead')
        .typeahead
          source: gon.quickie_completions
    @.closest('.modal').on 'hidden', => $(@).find(":input.typeahead").unbind()

  addTabIndices: ->
    tabIndex = 1
    for input in @list.find('input[type=text],select,button')
      $(input).attr('tabIndex', tabIndex)
      tabIndex++

  addScheduling: ($scheduling) ->
    @list.append new SchedulingEditor($scheduling)

  addNewForm: ($form, $cell) ->
    $form.find(':input#scheduling_employee_id').val($cell.data('employee_id')).change()
    $form.find(':input#scheduling_date').val($cell.data('date')).change()
    @list.append $form


window.CalendarEditor = CalendarEditor
