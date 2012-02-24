class QuickieEditor extends View
  @content: (params) ->
    name = "scheduling_#{params.id || 'new'}"
    @div class: 'control-group quickie', =>
      @label "Quickie", for: "#{name}_quickie"
      @div class: 'controls', =>
        @input type: 'text', value: params.value, id: "#{name}_quickie", name: 'scheduling[quickie]', outlet: 'input'

  initialize: (params) ->
    # input will be autocompleted, keybindings removed on modal box close
    @input
      .addClass('typeahead')
      .typeahead
        source: params.completions || [],
        sorter: @sorter
    @.closest('.modal').on 'hidden', => @input.unbind()

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

window.QuickieEditor = QuickieEditor
