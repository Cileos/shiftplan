describe 'SchedulingEditor', ->
  it 'is defined', ->
    expect(SchedulingEditor).not.toBeNull()

  beforeEach ->
    setFixtures sandbox
      id: 'scheduling'
      'data-id': 23
      'data-quickie': '9-17 Ackern'
    @editor = new SchedulingEditor scheduling: $('#scheduling'), quickies: []

  it 'provides outlet for quickie', ->
    expect(@editor.quickie).toExist()

  it 'creates QuickieEditor from data attributes', ->
    expect(QuickieEditor).not.toBeNull()
    quickie = spyOn(QuickieEditor, 'content').andCallThrough()
    editor = new SchedulingEditor scheduling: $('#scheduling'), quickies: []
    expect(quickie.mostRecentCall.args[0]).toEqual(value: '9-17 Ackern', completions: [], id: 23)

  it 'creates a form for the given scheduling', ->
    expect(@editor).toBe('form#edit_scheduling_23')
