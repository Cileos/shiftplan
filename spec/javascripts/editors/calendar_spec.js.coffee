describe 'CalendarEditor', ->
  beforeEach ->
    setFixtures sandbox
      id: 'scheduling'
      'data-id': 23
      'data-quickie': '9-17 Ackern'
  it 'is defined', ->
    expect(CalendarEditor).not.toBeNull()

  it 'creates form to edit every scheduling', ->
    addScheduling = spyOn(CalendarEditor.prototype, 'addScheduling')
    new CalendarEditor cell: $('<td><ul>  <li>first</li> <li>second</li> <li>third</li> </ul></td>'), form: $('<form></form>')
    expect(addScheduling).toHaveBeenCalled()
    expect(addScheduling.callCount).toEqual(3)
    expect(addScheduling.argsForCall[0][0].text()).toEqual( 'first' )
    expect(addScheduling.argsForCall[1][0].text()).toEqual( 'second' )
    expect(addScheduling.argsForCall[2][0].text()).toEqual( 'third' )

  it 'creates an editor when adding an existing scheduling', ->
    calendar = new CalendarEditor cell: $('<td><ul>  </ul></td>'), form: $('<form></form>')
    editor = spyOn(SchedulingEditor, 'content')
    scheduling = 'scheduling'
    window.gon = {}
    window.gon.quickie_completions = ['q1', 'q2']
    calendar.addScheduling scheduling
    expect(editor.mostRecentCall.args[0]).toEqual(scheduling: scheduling, quickies: ['q1','q2'])
    

  # no clue how to test this (yet)
  it 'focusses the first field'
  it 'adds tabindices'

  xdescribe 'form for new scheduling', ->
    it 'is reused from dom/rails', -> expect('done').toEqual('pending')
    it 'is always appended', -> expect('done').toEqual('pending')
    it 'is enriched with quickie completion', -> expect('done').toEqual('pending')
    it 'is prefilled with values of given scheduling', -> expect('done').toEqual('pending')
