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
      expect(@parsed.start_time).toEqual('9')

    it "should detect end hour", ->
      expect(@parsed.end_time).toEqual('17')

    it "formats start hour", ->
      expect(@parsed.verbose_start_time).toEqual('09:00')

    it "formats end hour", ->
      expect(@parsed.verbose_end_time).toEqual('17:00')

    it "should detect full unicode team name", ->
      expect(@parsed.team_name).toEqual('Brennstäbe wechseln')

    it "should detect team shortcut", ->
      expect(@parsed.team_shortcut).toEqual('Bw')

    xit 'can be reserialized', ->
      expect(@parsed.toString()).toEqual('9-17 Brennstäbe wechseln')

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
    parsed = Quickie.parse('12:05-20:13 Brennstäbe wechseln')
    expect( parsed ).not.toBeNull()
    expect( parsed.start_time ).toEqual('12:05')
    expect( parsed.end_time ).toEqual('20:13')
    expect( parsed.hour_range ).toEqual('12:05-20:13')
    expect( parsed.toString() ).toEqual('12:05-20:13 Brennstäbe wechseln')


  describe 'serialization', ->
    beforeEach ->
      @quickie = new Quickie()

    it 'handles one-digit full hours', ->
      @quickie.start_time = '06:00'
      @quickie.end_time = '09:00'
      @quickie.team_name = 'Brennstäbe wechseln'
      expect( @quickie.toString() ).toEqual('6-9 Brennstäbe wechseln')

    it 'handles full hours', ->
      @quickie.start_time = '12:00'
      @quickie.end_time = '20:00'
      @quickie.team_name = 'Brennstäbe wechseln'
      expect( @quickie.toString() ).toEqual('12-20 Brennstäbe wechseln')

    it 'handles minutes', ->
      @quickie.start_time = '12:05'
      @quickie.end_time = '20:13'
      @quickie.team_name = 'Brennstäbe wechseln'
      expect( @quickie.toString() ).toEqual('12:05-20:13 Brennstäbe wechseln')

    it 'handles one-digit hours and minutes', ->
      @quickie.start_time = '06:23'
      @quickie.end_time = '09:42'
      @quickie.team_name = 'Brennstäbe wechseln'
      expect( @quickie.toString() ).toEqual('06:23-09:42 Brennstäbe wechseln')

    it 'handles times only (without team)', ->
      @quickie.start_time = '06:23'
      @quickie.end_time = '09:42'
      @quickie.team_name = ''
      expect( @quickie.toString() ).toEqual('06:23-09:42')



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
