describe 'CalendarEditor', ->
  beforeEach ->
    setFixtures sandbox
      id: 'scheduling'
      'data-id': 23
      'data-quickie': '9-17 Ackern'
    window.gon = {}
    window.gon.quickie_completions = []

  it 'is defined', ->
    expect(CalendarEditor).not.toBeNull()

  it 'fetches multi-edit form from server to edit every scheduling', ->
    ajax = spyOn($, 'ajax')
    new CalendarEditor cell: $('<td><ul>  <li data-id=4>first</li> <li data-id=8>second</li> <li data-id=15>third</li> </ul></td>'), form: $('<form></form>')
    expect(ajax).toHaveBeenCalled()
    expect(ajax.callCount).toEqual(1)
    expect(ajax.argsForCall[0][0].data.ids).toEqual( [4, 8, 15] )

  xit 'creates an editor when adding an existing scheduling', ->
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

  describe 'form for new scheduling', ->
    beforeEach ->
      setFixtures sandbox
        id: 'cell'
        'data-employee_id': 42
        'data-date': '2012-12-21'
      # :input#scheduling_date actually a select, but this should work (TM)
      form = """
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
      @form = $(form)
      @calendar = new CalendarEditor cell: $('#cell'), form: @form

    it 'is reused from dom/rails', ->
      expect( @calendar ).toContain('form#new_form')

    it 'is prefilled with values of given scheduling', ->
      expect( @form.find('#scheduling_employee_id') ).toHaveValue(42)
      expect( @form.find('#scheduling_date') ).toHaveValue('2012-12-21')

    it 'is enriched with quickie completion', ->
      expect( @form ).toContain('div.quickie input[type=text].typeahead')
