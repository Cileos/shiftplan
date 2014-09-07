klass = null
view  = null

Thingy = Ember.Object.extend
  c: null
  r: null
  name: (->
    "#{@get('c')}#{@get('r')}"
  ).property('r', 'c')

module 'GroupingTable',
  setup: ->
    klass = GroupingTable.createView
      columnProperty: 'c'
      rowProperty: 'r'
    view = klass.create(
      columns: [
        Em.Object.create(name: 'A', c: 'A')
        Em.Object.create(name: 'B', c: 'B')
        Em.Object.create(name: 'C', c: 'C')
      ]
      content: [
        Thingy.create(c: 'A', r: 3)
        Thingy.create(c: 'B', r: 2)
        Thingy.create(c: 'C', r: 1)
      ]
      rows: [1,2,3]
    )
    Ember.run -> view.append()
  teardown: ->
    Ember.run -> view.remove()
    view = null
    klass = null


test 'is loaded', ->
  ok GroupingTable

test 'renders table', ->
  ok view.$().is('table')

test 'renders table head with column labels', ->
  equal( view.$('thead').length, 1)
  equal( view.$('thead th').length, 3)
  equal( view.$('thead th:nth(0)').text(), 'A')
  equal( view.$('thead th:nth(1)').text(), 'B')
  equal( view.$('thead th:nth(2)').text(), 'C')


test 'renders table head with column labels', ->
  equal( view.$('thead').length, 1)
  equal( view.$('thead th').length, 3)
  equal( view.$('thead th:nth(0)').text(), 'A')
  equal( view.$('thead th:nth(1)').text(), 'B')
  equal( view.$('thead th:nth(2)').text(), 'C')

test 'renders rows', ->
  equal( view.$('tbody > tr').length, 3)

test 'renders content into their cells', ->
  equal( view.$('tbody tr:nth(0) > td:nth(2)').text(), 'C1')
  equal( view.$('tbody tr:nth(1) > td:nth(1)').text(), 'B2')
  equal( view.$('tbody tr:nth(2) > td:nth(0)').text(), 'A3')

test 'reflects changes in content', ->
  Ember.run ->
    first = view.get('content.firstObject')
    first.set('c', 'B') # A3 -> B3

  equal( view.$('tbody tr:nth(0) > td:nth(2)').text(), 'C1')
  equal( view.$('tbody tr:nth(1) > td:nth(1)').text(), 'B2')
  notEqual( view.$('tbody tr:nth(2) > td:nth(0)').text(), 'A3')
  # FIXME that does not work yet without frakking everything up
  # equal( view.$('tbody tr:nth(2) > td:nth(1)').text(), 'B3')

test 're-renders when new content is set', ->
  Ember.run ->
    view.set 'content', [
      Thingy.create(c: 'A', r: 2)
      Thingy.create(c: 'B', r: 1)
      Thingy.create(c: 'C', r: 3)
    ]
  equal( view.$('tbody tr:nth(0) > td:nth(1)').text(), 'B1')
  equal( view.$('tbody tr:nth(1) > td:nth(0)').text(), 'A2')
  equal( view.$('tbody tr:nth(2) > td:nth(2)').text(), 'C3')

test 'adds new items', ->
  Ember.run ->
    thing = Thingy.create(c: 'C', r: 2)
    view.get('content').pushObject thing

  equal( view.$('tbody tr:nth(1) > td:nth(2)').text(), 'C2')

test 'removes deleted items', ->
  Ember.run ->
    content = view.get('content')
    thing = content.get('lastObject')
    content.removeObject(thing)

  notEqual( view.$('tbody tr:nth(0) > td:nth(2)').text(), 'C1')
