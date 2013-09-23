define ["lib/core/index"] , ->
  
  TimeLine = AC.Core.TimeLine
  Bar = AC.Core.Bar
  RVal = AC.Core.RVal
  Mode = AC.Core.Mode
  Position = AC.Core.Position
  RGen2 = AC.Core.RGen2

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


  describe "Position class" , ->
    it "plus", ->
      init_tl()

      expect(tl.position.plus(new RVal 1,2)).toEqual new Position
        timeline: tl
        cycle: 0
        bar: 0
        sub: new RVal 1,2

      expect(tl.position.plus(new RVal 5,1)).toEqual new Position
        timeline: tl
        cycle: 0
        bar: 1
        sub: new RVal 1

      expect(tl.position.plus(new RVal 11,2)).toEqual new Position
        timeline: tl
        cycle: 0
        bar: 1
        sub: new RVal 3,2  

      expect(tl.position.plus(new RVal 10)).toEqual new Position
        timeline: tl
        cycle: 1
        bar: 0
        sub: new RVal 2

      expect(tl.position.plus(new RVal 4)).toEqual new Position
        timeline: tl
        cycle: 0
        bar: 1
        sub: new RVal 0  

      tl.position = new Position
        timeline: tl
        cycle: 0
        bar: 0
        sub: new RVal 7,2

      console.log tl.position.plus(new RVal 1,2)
      expect(tl.position.plus(new RVal 1,2)).toEqual new Position
        timeline: tl
        cycle: 0
        bar: 1
        sub: new RVal 0 


    it "rval_to_ms", ->
      init_tl()
      expect(tl.position.rval_to_ms(new RVal 1,2)).toEqual 250
      expect(tl.position.rval_to_ms(new RVal 9,2)).toEqual 2500
      expect(tl.position.rval_to_ms(new RVal 21,2)).toEqual 7250

      tl.position = new Position
        timeline: tl
        cycle: 1
        bar: 1
        sub: new RVal 7,2 

      expect(tl.position.rval_to_ms(new RVal 1,2)).toEqual 500  