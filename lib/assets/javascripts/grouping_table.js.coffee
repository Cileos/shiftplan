GroupingTable = Ember.ContainerView.extend
  tagName: 'table'
  childViews: ['thead', 'tbody']
  thead: null # created on initialization so the instances do not share their childviews
  tbody: null
  columns: Ember.A(['', 1,2,3,4,5])
  rows: Ember.String.w('a b c d e')
  rowHeaderVisible: true
  content: Ember.A()
  columnProperty: 'column'
  rowProperty: 'row'
  init: ->
    c = {
      columnProperty: @get('columnProperty')
      rowProperty:    @get('rowProperty')
    }

    @set 'thead', Ember.ContainerView.create
      tagName: 'thead'
      childViews: ['header']
      header: Ember.CollectionView.create
        tagName: 'tr'
        contentBinding: 'parentView.parentView.columns'
        itemViewClass: Ember.View.extend
          tagName: 'th'
          template: Ember.Handlebars.compile '{{view.content}}'
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
            childViews: ['list']
            contentInCell: (->
              @get('parentView..parentView.contentInRow').filterProperty(c.columnProperty, @get('content'))
            ).property("parentView.columns.@each', 'parentView.parentView.contentInRow.@each.#{c.columnProperty}")

            # The actual list within the cell
            list: Ember.CollectionView.extend
              tagName: 'ul'
              contentBinding: 'parentView.contentInCell'
              itemViewClass: Ember.View.extend
                template: Ember.Handlebars.compile '{{view.content.name}}'

    @_super()

window.GroupingTable = GroupingTable
