describe 'QuickieParser', ->
  it 'is defined', ->
    expect(QuickieParser).not.toBeNull


  describe 'parsing a full quickie with whole hours and unicode', ->
    beforeEach ->
      @quickie = '9-17 Brennstäbe wechseln [Bw]'
      @parsed = QuickieParser.parse @quickie

    it "should detect hour range", ->
      expect(@parsed.hour_range).toEqual('9-17')

    it "should detect full unicode team name", ->
      expect(@parsed.team_name).toEqual('Brennstäbe wechseln')

    it "should detect team shortcut", ->
      expect(@parsed.team_shortcut).toEqual('Bw')

