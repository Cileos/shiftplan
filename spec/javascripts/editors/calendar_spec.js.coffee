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
