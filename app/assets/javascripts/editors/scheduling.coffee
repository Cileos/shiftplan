class SchedulingEditor extends View
  @content: (params) ->
    id = params.scheduling.data('id') || throw('scheduling without id given, needed to edit')
    name = "scheduling_#{id}"
    plan = params.scheduling.closest('table').data('plan_id')
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
          @input type: 'text', value: params.scheduling.data('quickie'), id: "#{name}_quickie", name: 'scheduling[quickie]', outlet: 'quickie'
      @button type: 'submit', class: 'btn btn-info', =>
        @i class: 'icon-ok-circle icon-white'
        # TODO I18n js
        @text ' Speichern'

  initialize: (params) ->
    # All quickie fields will be autocompleted, keybindings removed on modal box close
    @quickie
      .addClass('typeahead')
      .typeahead
        source: params.quickies,
        sorter: @sorter
    @.closest('.modal').on 'hidden', => @quickie.unbind()

  sorter: (items) ->
    [timeRange, shortCuts, beginsWith, rest] = [ [],[],[],[] ]
    for item in items
      list = if ~item.indexOf("#{@query}-") or ~item.indexOf("-#{@query}") # pre/suffixed by a dash
               timeRange
             else if ~item.indexOf("[#{@query}]") # case sensitive match on team [shortcut]
               shortCuts
             else if !item.toLowerCase().indexOf(@query.toLowerCase()) # we know it's included, check for index==0
               beginsWith
             else
               rest
      list.push(item)
    timeRange.concat(shortCuts, beginsWith, rest)

window.SchedulingEditor = SchedulingEditor

