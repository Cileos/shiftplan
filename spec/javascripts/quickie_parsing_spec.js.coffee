describe 'Quickie', ->
  it 'is defined', ->
    expect(Quickie).not.toBeNull()


  describe 'parsing a full quickie with whole hours and unicode', ->
    beforeEach ->
      @quickie = '9-17 Brennstäbe wechseln [Bw]'
      @parsed = Quickie.parse @quickie

    it "should be parsable", ->
      expect(@parsed).not.toBeNull()

    it "should detect hour range", ->
      expect(@parsed.hour_range).toEqual('9-17')

    it "should detect start hour", ->
      expect(@parsed.start_hour).toEqual('9')

    it "should detect end hour", ->
      expect(@parsed.end_hour).toEqual('17')

    it "should detect full unicode team name", ->
      expect(@parsed.team_name).toEqual('Brennstäbe wechseln')

    it "should detect team shortcut", ->
      expect(@parsed.team_shortcut).toEqual('Bw')

  it "should parse lonely hour range", ->
    parsed = Quickie.parse('9-17')
    expect( parsed ).not.toBeNull()
    expect( parsed.hour_range ).toEqual('9-17')

  it "should parse lonely team name", ->
    parsed = Quickie.parse('Brennstäbe wechseln')
    expect( parsed ).not.toBeNull()
    expect( parsed.team_name ).toEqual('Brennstäbe wechseln')

  it "should parse hour range with team name", ->
    parsed = Quickie.parse('9-17 Brennstäbe wechseln')
    expect( parsed ).not.toBeNull()
    expect( parsed.hour_range ).toEqual('9-17')
    expect( parsed.team_name ).toEqual('Brennstäbe wechseln')
