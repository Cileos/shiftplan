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


  # no clue how to test this (yet)
  it 'focusses the first field'
  it 'adds tabindices'

  describe 'form for new scheduling', ->
    beforeEach ->
      setFixtures sandbox
        id: 'cell'
        'data-employee-id': 42
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
