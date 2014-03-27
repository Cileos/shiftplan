alias = Ember.computed.alias

defaults =
  tagName: 'table'
  childViews: ['thead', 'tbody']
  columns: Ember.A(['', 1,2,3,4,5])
  rows: Ember.String.w('a b c d e')
  rowHeaderVisible: true
  columnProperty: 'column'
  rowProperty: 'row'
  columnHeaderProperty: 'name'
  cellLabelView: Ember.View.extend
    tagName: 'span'
    template: Ember.Handlebars.compile "{{view.content.name}}"
  cellListItemView: Ember.View.extend
    template: Ember.Handlebars.compile '{{view.content.name}}'
  # we tick this to force a re-evaluation of itemsInCell/itemsInRow.
  # FIXME this should not be neccessary but there seems to be something wrong
  # with bindings towards parentView
  fnord: 23
  tick: -> @incrementProperty 'fnord'
  items: alias('content')

GroupingTable = Ember.Namespace.create()


# bindings over two parentView are broken, so we alias
# them through the view hierarchy
# https://github.com/emberjs/ember.js/issues/3693
SettingsAliases = Ember.Mixin.create
  columns: alias('parentView.columns')
  rows: alias('parentView.rows')
  rowHeaderVisible: alias('parentView.rowHeaderVisible')
  fnord: alias('parentView.fnord')
  structure: alias('parentView.structure')
  items: alias('parentView.items')


GroupingTable.HeaderView = Ember.CollectionView.extend
  tagName: 'tr'
  content: alias('parentView.columns')

GroupingTable.BodyView = Ember.CollectionView.extend
  tagName: 'tbody'
  content: alias('rows')

GroupingTable.CellsView = Ember.CollectionView.extend
  content: alias('columns')
  structureInRow: alias('parentView.structureInRow')
  itemsInRow: alias('parentView.itemsInRow')


GroupingTable.createView = (options)->
  c = jQuery.extend {}, defaults, options

  Ember.ContainerView.extend c,
    init: ->
      window.t = this
      @_super()
    structure: Ember.A()
    content: Ember.A()
    thead: Ember.ContainerView.extend SettingsAliases,
      tagName: 'thead'
      childViews: ['header']
      header: GroupingTable.HeaderView.extend
        itemViewClass: Ember.View.extend
          tagName: 'th'
          template: Ember.Handlebars.compile "{{view.content.#{c.columnHeaderProperty}}}"

    tbody: GroupingTable.BodyView.extend SettingsAliases,
      # the row containing matching y
      itemViewClass: Ember.ContainerView.extend SettingsAliases,
        tagName: 'tr'
        otherFnord: (->
          console?.debug "other fnord", @get('fnord')
          @get('fnord') * 2
        ).property('fnord', 'Clockwork.fnord')
        childViews: (->
          if @get('rowHeaderVisible')
            ['heading', 'cells']
          else
            ['cells']
        ).property('rowHeaderVisible')

        structureInRow: (->
          console?.debug "row structure", @get('content')
          @get('structure').filterProperty(c.rowProperty, @get('content'))
        ).property("rows.@each', 'structure.@each.#{c.rowProperty}")

        itemsInRow: (->
          console?.debug "row items", @get('content'), @get('fnord')
          @get('items').filterProperty(c.rowProperty, @get('content'))
        ).property("rows.@each', 'items.@each.#{c.rowProperty}", 'fnord')

        heading: Ember.View.extend
          tagName: 'th'
          template: Ember.Handlebars.compile '{{view.parentView.content}} ({{view.parentView.itemsInRow.length}})'

        cells: GroupingTable.CellsView.extend SettingsAliases,

          # the cell containing matching x and y
          itemViewClass: Ember.ContainerView.extend SettingsAliases,
            tagName: 'td'

            childViews: (->
              if @get('itemsInCell.length') == 0
                ['label']
              else
                ['label', 'list']
            ).property('itemsInCell.length')

            structureInCell: (->
              @get('parentView.structureInRow').filterProperty(c.columnProperty, @get("content.#{c.columnProperty}"))
            ).property("columns.@each', 'structure.@each.#{c.columnProperty}")

            itemsInCell: (->
              console?.debug "cell", @get("content.#{c.columnProperty}")
              @get('parentView.itemsInRow').filterProperty(c.columnProperty, @get("content.#{c.columnProperty}"))
            ).property("columns.@each', 'parentView.itemsInRow.@each.#{c.columnProperty}", 'fnord', 'parentView.itemsInRow')

            # The actual list within the cell
            list: Ember.CollectionView.extend
              tagName: 'ul'
              contentBinding: 'parentView.itemsInCell'
              itemViewClass: c.cellListItemView

            label: c.cellLabelView.extend
              content: alias('parentView.structureInCell.firstObject')

window.GroupingTable = GroupingTable
