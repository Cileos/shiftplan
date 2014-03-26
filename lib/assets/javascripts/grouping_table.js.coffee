GroupingTable = Ember.ContainerView.extend
  tagName: 'table'
  childViews: ['thead', 'tbody']
  thead: null # created on initialization so the instances do not share their childviews
  tbody: null
  columns: Ember.A(['', 1,2,3,4,5])
  rows: Ember.String.w('a b c d e')
  rowHeaderVisible: true
  structure: Ember.A()
  content: Ember.A()
  columnProperty: 'column'
  rowProperty: 'row'
  columnHeaderProperty: 'name'
  cellLabelView: Ember.View.extend
    tagName: 'span'
    template: Ember.Handlebars.compile "{{view.content.name}}"
  cellListItemView: Ember.View.extend
    template: Ember.Handlebars.compile '{{view.content.name}}'

  init: ->
    c = {
      columnProperty: @get('columnProperty')
      rowProperty:    @get('rowProperty')
      cellLabelView:       @get('cellLabelView')
      cellListItemView:       @get('cellListItemView')
      columnHeaderProperty: @get('columnHeaderProperty')
    }

    @set 'thead', Ember.ContainerView.create
      tagName: 'thead'
      childViews: ['header']
      header: Ember.CollectionView.create
        tagName: 'tr'
        contentBinding: 'parentView.parentView.columns'
        itemViewClass: Ember.View.extend
          tagName: 'th'
          template: Ember.Handlebars.compile "{{view.content.#{c.columnHeaderProperty}}}"
    @set 'tbody', Ember.CollectionView.create
      tagName: 'tbody'
      contentBinding: 'parentView.rows'

      # the row containing matching y
      itemViewClass: Ember.ContainerView.extend
        tagName: 'tr'
        childViews: (->
          if @get('rowHeaderVisible')
            ['heading', 'cells']
          else
            ['cells']
        ).property('parentView.parentView.rowHeaderVisible')
        structureInRow: (->
          @get('parentView.parentView.structure').filterProperty(c.rowProperty, @get('content'))
        ).property("content.@each', 'parentView.parentView.structure.@each.#{c.rowProperty}")
        contentInRow: (->
          @get('parentView.parentView.content').filterProperty(c.rowProperty, @get('content'))
        ).property("content.@each', 'parentView.parentView.content.@each.#{c.rowProperty}")
        columnsBinding: 'parentView.parentView.columns'

        heading: Ember.View.extend
          tagName: 'th'
          template: Ember.Handlebars.compile '{{view.parentView.content}} ({{view.parentView.contentInRow.length}})'

        cells: Ember.CollectionView.extend
          contentBinding: 'parentView.columns'

          # the cell containing matching x and y
          itemViewClass: Ember.ContainerView.extend
            tagName: 'td'
            childViews: (->
              if @get('contentInCell.length') == 0
                ['label']
              else
                ['label', 'list']
            ).property('contentInCell.length')

            structureInCell: (->
              @get('parentView.parentView.structureInRow').filterProperty(c.columnProperty, @get("content.#{c.columnProperty}"))
            ).property("parentView.columns.@each', 'parentView.parentView.structureInRow.@each.#{c.columnProperty}")

            contentInCell: (->
              @get('parentView.parentView.contentInRow').filterProperty(c.columnProperty, @get("content.#{c.columnProperty}"))
            ).property("parentView.columns.@each', 'parentView.parentView.contentInRow.@each.#{c.columnProperty}")

            # The actual list within the cell
            list: Ember.CollectionView.extend
              tagName: 'ul'
              contentBinding: 'parentView.contentInCell'
              itemViewClass: c.cellListItemView

            label: c.cellLabelView.extend
              contentBinding: 'parentView.structureInCell.firstObject'

    @_super()

window.GroupingTable = GroupingTable
