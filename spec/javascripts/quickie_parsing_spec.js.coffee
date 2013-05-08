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
    expect( parsed.space_before_team ).toEqual(' ')

  it "should detect spaces before team to guess whether the user is going to enter one", ->
    parsed = Quickie.parse('9-17 ')
    expect( parsed ).not.toBeNull()
    expect( parsed.hour_range ).toEqual('9-17')
    expect( parsed.space_before_team ).toEqual(' ')

  it "parses time range with minutes", ->
    parsed = Quickie.parse('12:05-20:13')
    expect( parsed ).not.toBeNull()
    expect( parsed.start_hour ).toEqual('12')
    expect( parsed.start_minute ).toEqual('05')
    expect( parsed.end_hour ).toEqual('20')
    expect( parsed.end_minute ).toEqual('13')
    expect( parsed.hour_range ).toEqual('12:05-20:13')



  valid_quickies = [
      '9-23'
      '0-5'
      '1-2'
      '12-24'
      '20-8',
      '20:01-8:55',
      '20:01-08:55',
      '20:01-8'
    ]

  for valid_quickie in valid_quickies
    it "should parse '#{valid_quickie}'", ->
      parsed = Quickie.parse(valid_quickie)
      expect( parsed ).not.toBeNull()

  invalid_quickies = [
      '1-'
      '-23'
      '9-25'
      '1-88',
      '10:66-18',
      '10-18:66'
  ]

  for invalid_quickie in invalid_quickies
    it "should not parse '#{invalid_quickie}'", ->
      parsed = Quickie.parse(invalid_quickie)
      expect( parsed ).toBeNull()
