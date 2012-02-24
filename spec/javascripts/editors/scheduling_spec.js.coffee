describe 'SchedulingEditor', ->
  it 'is defined', ->
    expect(SchedulingEditor).not.toBeNull

  beforeEach ->
    setFixtures sandbox
      id: 'scheduling'
      'data-id': 23
      'data-quickie': '9-17 Ackern'
    @editor = new SchedulingEditor scheduling: $('#scheduling'), quickies: []

  it 'provides outlet for quickie', ->
    expect(@editor.quickie).toExist()
