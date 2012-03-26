class SchedulingEditor extends View
  @content: (params) ->
    id = params.scheduling.data('id') || throw('scheduling without id given, needed to edit')
    name = "scheduling_#{id}"
    plan = params.scheduling.closest('table').data('plan_id')
    organization = params.scheduling.closest('table').data('organization_id')
    url  = "/organizations/#{organization}/plans/#{plan}/schedulings/#{id}"
    # TODO routes for js
    @form class: 'form-horizontal well edit_scheduling', 'data-remote': true, id: "edit_#{name}", method: "POST", action: url, =>
      @input type: 'hidden', name: '_method', value: 'PUT'
      @a outlet: 'delete_button', class: 'btn btn-danger delete', href: url, 'data-remote': true, 'data-method': 'DELETE', =>
        @i class: 'icon-trash icon-white'
        # TODO I18n js
        @text ' Löschen'
      @subview 'quickie', new QuickieEditor value: params.scheduling.data('quickie'), completions: params.quickies, id: id
      @button type: 'submit', class: 'btn btn-info', =>
        @i class: 'icon-ok-circle icon-white'
        # TODO I18n js
        @text ' Speichern'


window.SchedulingEditor = SchedulingEditor

