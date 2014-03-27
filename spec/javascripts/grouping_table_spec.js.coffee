Thingy = Ember.Object.extend
  c: null
  r: null
  name: (->
    "#{@get('c')}#{@get('r')}"
  ).property('r', 'c')

describe 'GroupingTable', ->
  klass = null
  view  = null

  beforeEach ->
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

  afterEach ->
    Ember.run -> view.remove
    view = null
    klass = null

  it 'should be defined', ->
    expect(view).toBeDefined()

  it 'renders table', ->
    expect( view.$().is('table') ).toBe(true)

  it 'renders table head with column labels', ->
    expect( view.$('thead').length ).toEqual(1)
    expect( view.$('thead th').length ).toEqual(3)
    expect( view.$('thead th:nth(0)').text() ).toEqual('A')
    expect( view.$('thead th:nth(1)').text() ).toEqual('B')
    expect( view.$('thead th:nth(2)').text() ).toEqual('C')

  it 'renders rows', ->
    expect( view.$('tbody > tr').length ).toEqual(3)

  it 'renders content into their cells', ->
    expect( view.$('tbody tr:nth(0) > td:nth(2)').text() ).toEqual('C1')
    expect( view.$('tbody tr:nth(1) > td:nth(1)').text() ).toEqual('B2')
    expect( view.$('tbody tr:nth(2) > td:nth(0)').text() ).toEqual('A3')

  it 'reflects changes in content', ->
    Ember.run ->
      first = view.get('content.firstObject')
      first.set('c', 'B') # A3 -> B3

    expect( view.$('tbody tr:nth(0) > td:nth(2)').text() ).toEqual('C1')
    expect( view.$('tbody tr:nth(1) > td:nth(1)').text() ).toEqual('B2')
    expect( view.$('tbody tr:nth(2) > td:nth(0)').text() ).not.toEqual('A3')
    expect( view.$('tbody tr:nth(2) > td:nth(1)').text() ).toEqual('B3')

  it 're-renders when new content is set', ->
    Ember.run ->
      view.set 'content', [
        Thingy.create(c: 'A', r: 2)
        Thingy.create(c: 'B', r: 1)
        Thingy.create(c: 'C', r: 3)
      ]
    expect( view.$('tbody tr:nth(0) > td:nth(1)').text() ).toEqual('B1')
    expect( view.$('tbody tr:nth(1) > td:nth(0)').text() ).toEqual('A2')
    expect( view.$('tbody tr:nth(2) > td:nth(2)').text() ).toEqual('C3')
