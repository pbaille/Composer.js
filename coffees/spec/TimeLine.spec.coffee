define ["lib/core/index"], ->
  
  TimeLine = AC.Core.TimeLine
  Bar = AC.Core.Bar
  RVal = AC.Core.RVal
  Mode = AC.Core.Mode
  Position = AC.Core.Position
  RGen2 = AC.Core.RGen2

  window.rgen2 = new RGen2
    prob_array: [
      {rval: new RVal(1,2), occ: 1}
      {rval: new RVal(1,4), occ: 1}
      {rval: new RVal(3,8), occ: 3}
      {rval: new RVal(1,3), occ: 1}
      {rval: new RVal(1,6), occ: 1}
    ]
    advance: new RVal 2

  init_tl = ->
    window.tl = new TimeLine
      grid: [
        new Bar 
          beats: 4
          beat_val: new RVal 1
          bpm: 120
          resolution: new RVal 1,4
          harmonic_directives: [
            {at: new RVal(0), mode: new Mode("C Lyd")}
            {at: new RVal(2), mode: new Mode("Eb Lyd")}
          ]
        new Bar
          beats: 4
          beat_val: new RVal 1
          bpm: 60
          resolution: new RVal 1,4
          harmonic_directives: [
            {at: new RVal(0), mode: new Mode("B Lyd")}
            {at: new RVal(2), mode: new Mode("Ab Lyd")}
          ]
      ]
      cycle: true
      rgen: rgen2

  describe "TimeLine Class", ->
  	it "initialize", () ->

  	  expect(init_tl()).toBeTruthy()

  