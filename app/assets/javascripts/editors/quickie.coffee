# Encapsulates the editing of a Scheduling's Quickie
#
# needed params:
#   id:    database ID of the scheduling being edited
#   value: the current quickie
#
# optional
#   competions: quickies to complete for
class QuickieEditor extends View
  @content: (params) -> '' # FIXME still needed, but no View anymore

  initialize: (params) ->
    @input = params.element
    unless @input?
      console?.warn('no element given to QuickieEditor')
      return
    @completions = params.completions || gon.quickie_completions || []

    # input will be autocompleted, keybindings removed on modal box close
    @input
      .attr('autocomplete', 'off')
      .data('autocompletion', this)
      .addClass('autocompleted')
      .autocomplete
        source: @autocompleteSource
        appendTo: @input.closest('form')
    @one 'attach', =>
      $(@).closest('form').bind 'clockwork.remove', @destroy
      $('#modalbox').bind 'dialogclose', @destroy

  destroy: =>
    @input?.unbind().autocomplete('destroy')
    true

  autocompleteSource: (request, response) =>
    @query = request.term
    matched = (item for item in @completions when @matcher(item))
    response @sorter(matched)

  matcher: (item) ->
    return true for term in @query.split(/\s/) when ~item.toLowerCase().indexOf(term.toLowerCase())
    return false

  sorter: (items) ->
    [timeRange, shortCuts, beginsWith, rest] = [ [],[],[],[] ]
    if m = @query.match(/\b(\S{1,3})$/) # 1..3 characters alone at the end
      unless m[1].match(/-\d/)        # but no time range please
        shortCutMatcher = "[#{m[1]}]"
    items.sort() # presort lexically
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

$.fn.edit_quickie = ->
  $(this).not('.autocompleted').each ->
    new QuickieEditor element: $(this)
