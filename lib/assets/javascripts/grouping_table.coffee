GroupingTable = Ember.ContainerView.extend
  tagName: 'table'
  childViews: ['thead', 'tbody']
  thead: null # created on initialization so the instances do not share their childviews
  tbody: null
  columns: Ember.A(['', 1,2,3,4,5])
  rows: Ember.String.w('a b c d e')
  content: Ember.A()
  init: ->
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
        childViews: ['heading', 'cells']
        contentInRow: (->
          @get('parentView.parentView.content').filterProperty('y', @get('content'))
        ).property('content.@each', 'parentView.parentView.content.@each.y')
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
              @get('parentView..parentView.contentInRow').filterProperty('x', @get('content'))
            ).property('parentView.columns.@each', 'parentView.parentView.contentInRow.@each.x')

            # The actual list within the cell
            list: Ember.CollectionView.extend
              tagName: 'ul'
              contentBinding: 'parentView.contentInCell'
              itemViewClass: Ember.View.extend
                template: Ember.Handlebars.compile '{{view.content.name}}'

    @_super()

window.GroupingTable = GroupingTable
