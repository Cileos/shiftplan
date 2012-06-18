# Encapsulates the editing of a Scheduling's Quickie
#
# needed params:
#   id:    database ID of the scheduling being edited
#   value: the current quickie
#
# optional
#   competions: quickies to complete for
class QuickieEditor extends View
  @content: (params) ->
    name = "scheduling_#{params.id || 'new'}"
    @div class: 'control-group quickie', =>
      @label "Quickie", for: "#{name}_quickie", class: 'control-label'
      @div class: 'controls', =>
        @input type: 'text', value: params.value, id: "#{name}_quickie", name: 'scheduling[quickie]', outlet: 'input'

  initialize: (params) ->
    # input will be autocompleted, keybindings removed on modal box close
    @input
      .attr('autocomplete', 'off')
      .addClass('typeahead')
      .typeahead
        source: params.completions || gon.quickie_completions,
        sorter: @sorter
        matcher: @matcher
    @one 'attach', =>
      $(@).closest('form').bind 'shiftplan.remove', @destroy
      $('#modalbox').bind 'dialogclose', @destroy

  destroy: =>
    @input?.unbind().data('typeahead')?.$menu?.remove()
    true

  matcher: (item) ->
    return true for term in @query.split(/\s/) when ~item.toLowerCase().indexOf(term.toLowerCase())
    return false

  sorter: (items) ->
    [timeRange, shortCuts, beginsWith, rest] = [ [],[],[],[] ]
    if m = @query.match(/\b(\S{1,3})$/) # 1..3 characters alone at the end
      unless m[1].match(/-\d/)        # but no time range please
        shortCutMatcher = "[#{m[1]}]"
    for item in items
      list = if ~item.indexOf("#{@query}-") or ~item.indexOf("-#{@query}") # pre/suffixed by a dash
               timeRange
             else if shortCutMatcher and ~item.indexOf(shortCutMatcher)
               # case sensitive match on team [shortcut], must be at end of input
               shortCuts
             else if !item.toLowerCase().indexOf(@query.toLowerCase()) # we know it's included, check for index==0
               beginsWith
             else
               rest
      list.push(item)
    timeRange.concat(shortCuts, beginsWith, rest)

window.QuickieEditor = QuickieEditor
