describe 'SchedulingEditor', ->
  beforeEach ->
    setFixtures sandbox
      id: 'scheduling'
      'data-id': 23
      'data-quickie': '9-17 Ackern'

    @editor = new SchedulingEditor scheduling: $('#scheduling'), quickies: []

  it 'is defined', ->
    expect(SchedulingEditor).not.toBeNull

  it 'has provides typeahead for quickie field', ->
    expect(@editor.quickie).toExist()
    expect(@editor.quickie).toHaveClass('typeahead')
    expect(@editor.quickie.data('typeahead')).toBeDefined()

  describe 'quickie typeahead', ->
    beforeEach ->
      @addMatchers
        toBeCompletedBy: (input, editor) ->
          editor.query = input
          editor.matcher(@actual)


    it 'should complete full time ranges', ->
      expect('9-17 Ackern').toBeCompletedBy('9-17', @editor)
      expect('17-23 laut Hacken').not.toBeCompletedBy('9-17', @editor)

    it 'should complete start hour', ->
      expect('17-23 laut Hacken').toBeCompletedBy('17', @editor)

    it 'should complete end hour', ->
      expect('17-23 laut Hacken').toBeCompletedBy('23', @editor)

    it 'should complete part of end hour', ->
      expect('17-23 laut Hacken').toBeCompletedBy('1', @editor)

    it 'should complete full words of team name', ->
      expect('17-23 laut Hacken').toBeCompletedBy('laut', @editor)
      expect('17-23 laut Hacken').toBeCompletedBy('Hacken', @editor)

    it 'should complete suffix of words in team name', ->
      expect('17-23 laut Hacken').toBeCompletedBy('ken', @editor)

    it 'should complete prefix of words in team name', ->
      expect('17-23 laut Hacken').toBeCompletedBy('Hack', @editor)

    it 'should ignore case', ->
      expect('17-23 laut HacKen').toBeCompletedBy('hAck', @editor)

    it 'should complete shortcut in square brackets', ->
      expect('17-23 laut Hacken [lH]').toBeCompletedBy('lh', @editor)
      expect('17-23 laut Hacken [lH]').toBeCompletedBy('[lh', @editor)
