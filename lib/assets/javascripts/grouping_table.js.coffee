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

createGroupingTableView = (options)->
  c = jQuery.extend {}, defaults, options

  Ember.ContainerView.extend c,
    structure: Ember.A()
    content: Ember.A()
    thead: Ember.ContainerView.create
      tagName: 'thead'
      childViews: ['header']
      header: Ember.CollectionView.create
        tagName: 'tr'
        contentBinding: 'parentView.parentView.columns'
        itemViewClass: Ember.View.extend
          tagName: 'th'
          template: Ember.Handlebars.compile "{{view.content.#{c.columnHeaderProperty}}}"

    tbody: Ember.CollectionView.extend
      tagName: 'tbody'
      rowsBinding: 'parentView.rows'
      contentBinding: 'rows'
      structureBinding: 'parentView.structure'
      itemsBinding: 'parentView.content'

      # the row containing matching y
      itemViewClass: Ember.ContainerView.extend
        tagName: 'tr'
        columnsBinding: 'parentView.parentView.columns'
        childViews: (->
          if @get('rowHeaderVisible')
            ['heading', 'cells']
          else
            ['cells']
        ).property('parentView.parentView.rowHeaderVisible')

        structureInRow: (->
          console?.debug "row", @get('content')
          @get('parentView.parentView.structure').filterProperty(c.rowProperty, @get('content'))
        ).property("parentView.rows.@each', 'parentView.structure.@each.#{c.rowProperty}")

        itemsInRow: (->
          @get('parentView.parentView.content').filterProperty(c.rowProperty, @get('content'))
        ).property("parentView.rows.@each', 'parentView.items.@each.#{c.rowProperty}")

        heading: Ember.View.extend
          tagName: 'th'
          template: Ember.Handlebars.compile '{{view.parentView.content}} ({{view.parentView.itemsInRow.length}})'

        cells: Ember.CollectionView.extend
          columnsBinding: 'parentView.columns'
          contentBinding: 'columns'
          structureBinding: 'parentView.structureInRow'
          itemsBinding: 'parentView.itemsInRow'

          # the cell containing matching x and y
          itemViewClass: Ember.ContainerView.extend
            tagName: 'td'
            childViews: (->
              if @get('itemsInCell.length') == 0
                ['label']
              else
                ['label', 'list']
            ).property('itemsInCell.length')

            structureInCell: (->
              @get('parentView.parentView.structureInRow').filterProperty(c.columnProperty, @get("content.#{c.columnProperty}"))
            ).property("parentView.columns.@each', 'parentView.structure.@each.#{c.columnProperty}")

            itemsInCell: (->
              @get('parentView.parentView.itemsInRow').filterProperty(c.columnProperty, @get("content.#{c.columnProperty}"))
            ).property("parentView.columns.@each', 'parentView.items.@each.#{c.columnProperty}")

            # The actual list within the cell
            list: Ember.CollectionView.extend
              tagName: 'ul'
              contentBinding: 'parentView.itemsInCell'
              itemViewClass: c.cellListItemView

            label: c.cellLabelView.extend
              contentBinding: 'parentView.structureInCell.firstObject'

window.createGroupingTableView = createGroupingTableView
