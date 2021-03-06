describe 'Calendar Cursor', ->
  beforeEach ->
    @$sandbox = $('#sandbox')

    @$calendar = $('<div></div>').attr('id', 'calendar').appendTo(@$sandbox)
    @cursor = new CalendarCursor @$calendar

  afterEach ->
    @cursor.disable()


  describe 'pressing arrow down', ->
    beforeEach ->
      @event = jQuery.Event("keydown")
      @event.ctrlKey = false
      @event.which = 40 # arrow down
      spyOn @cursor, 'down'

    describe 'in calendar', ->
      it 'should go down', ->
        @$calendar.trigger @event
        expect( @cursor.down ).toHaveBeenCalled()

    describe 'in a text input field', ->
      it 'should be ignored', ->
        $field = $('<input type="text" />').appendTo('#calendar')
        @event.srcElement = $field
        @$calendar.trigger @event
        expect( @cursor.down ).not.toHaveBeenCalled()


  describe 'pressing the "n" key', ->
    beforeEach ->
      @event = jQuery.Event("keydown")
      @event.ctrlKey = false
      @event.which = 78 # n
      spyOn @cursor, 'orientate'
      spyOn @cursor, 'create'

    describe 'in calendar', ->
      it 'should open modal box to create new scheduling', ->
        @$calendar.trigger @event
        expect( @cursor.create ).toHaveBeenCalled()

    describe 'in a text input field', ->
      it 'should be ignored', ->
        $field = $('<input type="text" />').appendTo('#calendar')
        @event.srcElement = $field
        @$calendar.trigger @event
        expect( @cursor.create ).not.toHaveBeenCalled()

  describe '#findByCid', ->
    it 'finds an item within the calendar', ->
      cid = "2342"
      content = 'the correct item' # just to match more beautiful
      $item = $('<div></div>').
                addClass('scheduling').
                text(content).
                attr('data-cid', cid).
                appendTo( @$calendar )
      expect( @cursor.findByCid(cid).text() ).toEqual(content)
