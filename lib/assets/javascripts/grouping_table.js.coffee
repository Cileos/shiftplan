alias = Ember.computed.alias

defaults =
  tagName: 'table'
  childViews: ['thead', 'tbody']
  columns: Ember.A(['', 1,2,3,4,5])
  rows: Ember.String.w('a b c d e')
  rowHeaderVisible: true
  columnProperty: 'column'
  sortProperty: 'id'
  rowProperty: 'row'
  columnHeaderProperty: 'name'
  cellLabelView: Ember.View.extend
    tagName: 'span'
    template: Ember.Handlebars.compile "{{view.content.name}}"
  cellListItemView: Ember.View.extend
    template: Ember.Handlebars.compile '{{view.content.name}}'
  rowHeaderView: Ember.View.extend
    tagName: 'th'
    template: Ember.Handlebars.compile '{{view.parentView.content}} ({{view.parentView.itemsInRow.length}})'

  items: alias('content')

GroupingTable = Ember.Namespace.create()


# bindings over two parentView are broken, so we alias
# them through the view hierarchy
# https://github.com/emberjs/ember.js/issues/3693
SettingsAliases = Ember.Mixin.create
  columns: alias('parentView.columns')
  rows: alias('parentView.rows')
  rowHeaderVisible: alias('parentView.rowHeaderVisible')
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
        childViews:
          Ember.computed ->
            if @get('rowHeaderVisible')
              ['heading', 'cells']
            else
              ['cells']
          .property('rowHeaderVisible')

        structureInRow: (->
          @get('structure').filterProperty(c.rowProperty, @get('content'))
        ).property("rows.@each", "structure.@each.#{c.rowProperty}")

        itemsInRow:
          Ember.computed ->
            @get('items').filterProperty(c.rowProperty, @get('content'))
          .property("rows.@each", "items.length")

        heading: c.rowHeaderView.extend()

        ############################################################################
        # Ember bindings get lost here
        ############################################################################
        cells: GroupingTable.CellsView.extend SettingsAliases,

          # the cell containing matching x and y
          itemViewClass: Ember.ContainerView.extend SettingsAliases,
            tagName: 'td'
            classNameBindings: ['isFocus:focus']
            childViews: ['label', 'list']
            isFocus: false

            structureInCell: (->
              @get('parentView.structureInRow').filterProperty(c.columnProperty, @get("content.#{c.columnProperty}"))
            ).property("columns.@each", "structure.@each.#{c.columnProperty}")

            itemsInCell: (->
              @get('parentView.itemsInRow').filterProperty(c.columnProperty, @get("content.#{c.columnProperty}")).sortBy(c.sortProperty...)
            ).property("columns.@each", "parentView.itemsInRow.@each.#{c.columnProperty}")

            # The actual list within the cell
            list: Ember.CollectionView.extend
              tagName: 'ul'
              content: alias('parentView.itemsInCell')
              itemViewClass: c.cellListItemView.extend()

            label: c.cellLabelView.extend
              content: alias('parentView.structureInCell.firstObject')

            mouseEnter: (evt)-> @set 'isFocus', true
            mouseLeave: (evt)-> @set 'isFocus', false

window.GroupingTable = GroupingTable
