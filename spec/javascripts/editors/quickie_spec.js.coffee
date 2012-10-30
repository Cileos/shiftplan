describe 'QuickieEditor', ->
  it 'is defined', ->
    expect(QuickieEditor).not.toBeNull

  beforeEach ->
    setFixtures sandbox
      id: 'modalbox',
      class: 'modal'
    @form = """
             <form id="new_form">
                 <div class="control-group">
                   <div class="controls">
                     <input id="scheduling_quickie" name="scheduling[quickie]" />
                   </div>
                 </div>
                 <input id="scheduling_employee_id" />
                 <input id="scheduling_date" />
             </form>
           """
    $('#modalbox').append @form
    @editor = new QuickieEditor element: $('#modalbox #scheduling_quickie'), completions: []

  it 'provides outlet for input', ->
    expect(@editor.input).toExist()

  it 'provides autocompletion for input field', ->
    expect(@editor.input).toHaveClass('ui-autocomplete-input')
    expect(@editor.input.data('autocompletion')).toBeDefined()

  it 'cleans up autocompletion menu when closing modal window', ->
    setFixtures sandbox
      id: 'modalbox',
      class: 'modal'
    $('#modalbox').append @editor
    autocompletion = @editor.input.data('autocompletion')
    # FIXME disabled for a while
    #expect( autocompletion.$menu.closest('body') ).toExist()
    #$('#modalbox').trigger 'dialogclose'
    #expect( autocompletion.$menu.closest('body') ).not.toExist()

  describe 'autocompletion', ->
    beforeEach ->
      completer = @editor.input.data('autocompletion')

      @addMatchers
        toBeCompletedBy: (input) ->
          completer.query = input
          completer.matcher(@actual)
        toBeSortedBy: (input, expected) ->
          completer.query = input
          sorted = completer.sorter(@actual)
          ok = true
          for i in [0...expected.length]
            ok = ok and expected[i] is sorted[i]
          ok

    it 'should complete full time ranges', ->
      expect('9-17 Ackern').toBeCompletedBy('9-17')
      expect('17-23 laut Hacken').not.toBeCompletedBy('9-17')

    it 'should complete start hour', ->
      expect('17-23 laut Hacken').toBeCompletedBy('17')

    it 'should complete end hour', ->
      expect('17-23 laut Hacken').toBeCompletedBy('23')

    it 'should complete part of end hour', ->
      expect('17-23 laut Hacken').toBeCompletedBy('1')

    it 'should complete full words of team name', ->
      expect('17-23 laut Hacken').toBeCompletedBy('laut')
      expect('17-23 laut Hacken').toBeCompletedBy('Hacken')

    it 'should complete suffix of words in team name', ->
      expect('17-23 laut Hacken').toBeCompletedBy('ken')

    it 'should complete prefix of words in team name', ->
      expect('17-23 laut Hacken').toBeCompletedBy('Hack')

    it 'should ignore case', ->
      expect('17-23 laut HacKen').toBeCompletedBy('hAck')

    it 'should complete shortcut in square brackets', ->
      expect('17-23 laut Hacken [lH]').toBeCompletedBy('lh')
      expect('17-23 laut Hacken [lH]').toBeCompletedBy('[lh')

    it 'should show matches on beginning before matches on part', ->
      quickies = ['Brathering', 'TheBrain']
      expect(quickies).toBeSortedBy('The', ['TheBrain', 'Brathering'])
      expect(quickies).toBeSortedBy('Bra', ['Brathering', 'TheBrain'])

    it 'should show matches on time range before all other matches', ->
      quickies = ['1-23 Korrigiere10Zeilen', '10-11 3Mettbrote']
      expect(quickies).toBeSortedBy('10', ['10-11 3Mettbrote', '1-23 Korrigiere10Zeilen'])
      expect(quickies).toBeSortedBy('3', ['1-23 Korrigiere10Zeilen', '10-11 3Mettbrote'])

    it 'should show matches on shortcut before matches on team names', ->
      quickies = [aalen, zzschlafen] = ['Aalen [Zz]', 'Zzschlafen [Aa]']
      expect(quickies).toBeSortedBy('Aa', [zzschlafen,aalen])
      expect(quickies).toBeSortedBy('Zz', [aalen,zzschlafen])

    it 'should prefer team shortcuts only if they match case sensitive', ->
      quickies = [aalen, zzschlafen] = ['Aalen [Zz]', 'Zzschlafen [Aa]']
      expect(quickies).toBeSortedBy('aA', [aalen,zzschlafen])
      expect(quickies).toBeSortedBy('zz', [zzschlafen,aalen])

